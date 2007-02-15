Return-Path: <linux-kernel-owner+w=401wt.eu-S1161397AbXBOVb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161397AbXBOVb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161398AbXBOVb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:31:56 -0500
Received: from senderslist.sierrawireless.com ([204.50.29.40]:58751 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161397AbXBOVbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:31:55 -0500
Message-ID: <45D4D15D.1030802@sierrawireless.com>
Date: Thu, 15 Feb 2007 13:32:13 -0800
From: Kevin Lloyd <klloyd@sierrawireless.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux@sierrawireless.com, greg@kroah.com
CC: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: [PATCH 2.6.20-git11 01/01] usb: Remove Airprime device from option.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2007 21:31:52.0682 (UTC) FILETIME=[B56F64A0:01C75148]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15000.000
X-TM-AS-Result: No--8.026200-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from: Kevin Lloyd <linux@sierrawireless.com>

This patch removes the Airprime 5220 device (branded as Audiovox) from
the option.c driver. This device is already supported by the sierra.c
driver.

This was based off of the option.c driver found in kernel 2.6.20-git11.

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>

--- 

--- linux-2.6.20-git11-option-change/drivers/usb/serial/option.c.orig	2007-02-15 10:54:42.000000000 -0800
+++ linux-2.6.20-git11-option-change/drivers/usb/serial/option.c	2007-02-15 10:55:20.000000000 -0800
@@ -69,7 +69,6 @@ static int  option_send_setup(struct usb
 /* Vendor and product IDs */
 #define OPTION_VENDOR_ID                0x0AF0
 #define HUAWEI_VENDOR_ID                0x12D1
-#define AUDIOVOX_VENDOR_ID              0x0F3D
 #define NOVATELWIRELESS_VENDOR_ID       0x1410
 #define ANYDATA_VENDOR_ID               0x16d5
 
@@ -81,7 +80,6 @@ static int  option_send_setup(struct usb
 #define OPTION_PRODUCT_GTMAX36          0x6701
 #define HUAWEI_PRODUCT_E600             0x1001
 #define HUAWEI_PRODUCT_E220             0x1003
-#define AUDIOVOX_PRODUCT_AIRCARD        0x0112
 #define NOVATELWIRELESS_PRODUCT_U740    0x1400
 #define ANYDATA_PRODUCT_ID              0x6501
 
@@ -94,7 +92,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GTMAX36) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
-	{ USB_DEVICE(AUDIOVOX_VENDOR_ID, AUDIOVOX_PRODUCT_AIRCARD) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID,NOVATELWIRELESS_PRODUCT_U740) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ID) },
 	{ } /* Terminating entry */
@@ -109,7 +106,6 @@ static struct usb_device_id option_ids1[
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GTMAX36) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
-	{ USB_DEVICE(AUDIOVOX_VENDOR_ID, AUDIOVOX_PRODUCT_AIRCARD) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID,NOVATELWIRELESS_PRODUCT_U740) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ID) },
 	{ } /* Terminating entry */


