//
//  ANNViewController.m
//  TestLocation
//
//  Created by lanou3g on 14-7-27.
//  Copyright (c) 2014年 ;. All rights reserved.
//

#import "ANNViewController.h"


@interface ANNViewController ()
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *latitude;

@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ANNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建CLLocationManager对象
    self.locationManager = [[CLLocationManager alloc] init];
    //设置代理为自己
    self.locationManager.delegate = self;
    
}
- (IBAction)locationButton:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    
    //将经度显示到label上
    self.longitude.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    self.latitude.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //将获得的所有信息显示到label上
             self.location.text = placemark.name;
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             NSLog(@"city = %@", city);
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

//- (void)locationManager:(CLLocationManager *)manager
//	 didUpdateLocations:(NSArray *)locations
//{
//    NSLog(@"longitude = %f", ((CLLocation *)[locations lastObject]).coordinate.longitude);
//    NSLog(@"latitude = %f", ((CLLocation *)[locations lastObject]).coordinate.latitude);
//    
//    [manager stopUpdatingLocation];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
