//
//  ViewController.m
//  Gmap
//
//  Created by Chris Chen on 21/08/13.
//  Copyright (c) 2013 Tickbox Pty. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MarkerView.h"
#import <BlocksKit/BlocksKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *ibMapView;
@property (weak, nonatomic) IBOutlet GMSPanoramaView *ibPanoramaView;
@property (weak, nonatomic) IBOutlet UITextField *ibSearchTextField;
@property (strong, nonatomic) CLGeocoder *geocoder;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // setup map
    self.ibMapView.delegate = self;
    self.ibMapView.settings.compassButton = YES;
    self.ibMapView.settings.indoorPicker = YES;
    self.ibMapView.settings.myLocationButton = YES;
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.8136
                                                            longitude:144.9631
                                                                 zoom:10];
    self.ibMapView.camera = camera;
    self.ibMapView.myLocationEnabled = YES;
    self.ibMapView.settings.rotateGestures = NO;
    
    // Creates a marker in the center of the map.
    GMSMarker *sydneyMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(-33.86, 151.20)];
    sydneyMarker.title = @"Sydney";
    sydneyMarker.snippet = @"House is expensive here!";
    sydneyMarker.map = self.ibMapView;
    sydneyMarker.icon = [UIImage imageNamed:@"pin3"];
    sydneyMarker.infoWindowAnchor = CGPointMake(0.5, 1);
    
    GMSMarker *melbourneMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(-37.8136, 144.9631)];
    melbourneMarker.title = @"Melbourne";
    melbourneMarker.snippet = @"It's still cold here!";
    melbourneMarker.map = self.ibMapView;
    melbourneMarker.icon = [UIImage imageNamed:@"pin3"];
    melbourneMarker.infoWindowAnchor = CGPointMake(0.5, 1);
    
    GMSCircle *circ = [GMSCircle circleWithPosition:melbourneMarker.position
                                             radius:5000];
    
    circ.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.6];
    circ.strokeColor = [UIColor blueColor];
    circ.strokeWidth = 2;
    circ.map = self.ibMapView;
    
    
    [self.ibPanoramaView moveNearCoordinate:melbourneMarker.position];
    
    self.geocoder = [[CLGeocoder alloc] init];
}

#pragma mark - GMSMapViewDelegate
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    MarkerView *view = [[NSBundle mainBundle] loadNibNamed:@"MarkerView" owner:self options:nil].lastObject;
    view.ibLabel1.text = marker.title;
    view.ibLabel2.text = marker.snippet;
    return view;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [UIAlertView showAlertViewWithTitle:nil
                                message:[NSString stringWithFormat:@"should display detail of %@", marker.title]
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil
                                handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          //
                      }];
}

- (IBAction)displayMapView:(id)sender {
    self.ibPanoramaView.hidden = YES;
    self.ibMapView.hidden = NO;
}

- (IBAction)displayPanoView:(id)sender {
    self.ibPanoramaView.hidden = NO;
    self.ibMapView.hidden = YES;
}

- (IBAction)keywordChanged:(id)sender {
    if (self.ibSearchTextField.text.length) {
        [self.geocoder cancelGeocode];
        NSLog(@"============NEW SEARCH============");
        [self.geocoder geocodeAddressString:self.ibSearchTextField.text
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         for (CLPlacemark *placemark in placemarks) {
                             NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
                             NSString *addressString = [lines componentsJoinedByString:@", "];
                             NSLog(@"Address: %@", addressString);
                         }
                     }];
    }
}
@end
