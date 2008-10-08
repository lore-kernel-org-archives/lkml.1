Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYJHD7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYJHD7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 23:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYJHD7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 23:59:04 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62169 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYJHD7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 23:59:03 -0400
Date: Wed, 08 Oct 2008 11:58:59 +0800
From: Franko Fang <huananhu@huawei.com>
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card productIDs,
 fix kernel 2.6.27-rc7
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       zhangqianchun@huawei.com
Message-id: <004d01c928fa$31ebc5c0$f9100b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <faf7b1bd45d66.45d66faf7b1bd@huawei.com>
 <20081008032139.GA14931@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, ok, and I will try it again.
Thanks.

----- Original Message ----- 
From: "Greg KH" <greg@kroah.com>
To: "fangxiaozhi 00110321" <huananhu@huawei.com>
Cc: <linux-usb@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; <zhangqianchun@huawei.com>
Sent: Wednesday, October 08, 2008 11:21 AM
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card productIDs, fix kernel 2.6.27-rc7


> On Wed, Oct 08, 2008 at 09:31:35AM +0800, fangxiaozhi 00110321 wrote:
>>   From: fangxiaozhi <huananhu@huawei.com>
>>  
>>  1. This patch is based on the kernel of 2.6.27-rc7 
>>  2. In this patch, we want to do one thing: add more Huawei product IDs into the USB driver. Then it can support  more Huawei data card devices. So to declare the unusual device for new Huawei data card devices 
>>  in unusual_devs.h and to declare more new product IDs in option.c.
>>  3. To modify the data value and length in the function of 
>>  usb_stor_huawei_e220_init in initializers.c
>>    That's because based on the USB standard, while sending SET_FETURE_D to the device, it requires the corresponding data to be zero, and its sending length also must be zero.
>>    In our old solution, it can be compatible with our WCDMA data card devices, but can not support our CDMA data card devices. 
>>     But in this new solution, it can be compatible with all of our data card devices.
>> 
>>  Signed-off-by: fangxiaozhi <huananhu@huawei.com>
>>  -------------------------------------------------------------------
>> 
>> diff -uprN -X linux-2.6.27-rc7-orig/Documentation/dontdiff linux-2.6.27-rc7-orig/drivers/usb/serial/option.c linux-2.6.27-rc7/drivers/usb/serial/option.c
>> --- linux-2.6.27-rc7-orig/drivers/usb/serial/option.c 2008-09-22 06:29:55.000000000 +0800
>> +++ linux-2.6.27-rc7/drivers/usb/serial/option.c 2008-09-24 12:00:14.000000000 +0800
>> @@ -106,11 +106,20 @@ static int  option_send_setup(struct tty
>>  #define HUAWEI_PRODUCT_E220                 0x1003
>>  #define HUAWEI_PRODUCT_E220BIS                 0x1004
>>  #define HUAWEI_PRODUCT_E1401                 0x1401
>> +#define HUAWEI_PRODUCT_E1402                 0x1402
> 
> Hm, all of the tabs seem to have been converted to spaces in this patch,
> and it does not apply at all.
> 
> Care to fix your email client settings and try again?
> 
> thanks,
> 
> greg k-h
