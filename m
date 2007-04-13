Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXDMDIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXDMDIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 23:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXDMDIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 23:08:47 -0400
Received: from mail.bandrich.com ([211.72.242.84]:58362 "EHLO
	mail.bandrich.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbXDMDIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 23:08:46 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2007 23:08:45 EDT
Subject: [PATCH] USB: BandRich BandLuxe HSDPA Data Card Driver
From: Leon Leong <upleong@bandrich.com>
To: smurf@smurf.noris.de
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Fri, 13 Apr 2007 11:03:07 +0800
Message-Id: <1176433387.4649.8.camel@upleong.brtpe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the detection for the BandRich BandLuxe C100/C100S/C120 
HSDPA Data Card.  With the vendor and product IDs are set properly, 
the data card can be detected and works fine.
It was patched based on Kernel 2.6.20.1.

Signed-off-by: Leon Leong <upleong@bandrich.com>

---

Index: drivers/usb/serial/option.c
===================================================================
--- linux-2.6.20.1/drivers/usb/serial/option.c.orig	2007-02-05
02:44:54.000000000 +0800
+++ linux-2.6.20.1/drivers/usb/serial/option.c	2007-04-13
10:36:33.000000000 +0800
@@ -72,6 +72,7 @@ static int  option_send_setup(struct usb
 #define AUDIOVOX_VENDOR_ID              0x0F3D
 #define NOVATELWIRELESS_VENDOR_ID       0x1410
 #define ANYDATA_VENDOR_ID               0x16d5
+#define BANDRICH_VENDOR_ID              0x1A8D
 
 #define OPTION_PRODUCT_OLD              0x5000
 #define OPTION_PRODUCT_FUSION           0x6000
@@ -84,6 +85,8 @@ static int  option_send_setup(struct usb
 #define AUDIOVOX_PRODUCT_AIRCARD        0x0112
 #define NOVATELWIRELESS_PRODUCT_U740    0x1400
 #define ANYDATA_PRODUCT_ID              0x6501
+#define BANDRICH_PRODUCT_C100_1         0x1002
+#define BANDRICH_PRODUCT_C100_2         0x1003
 
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_OLD) },
@@ -97,6 +100,8 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(AUDIOVOX_VENDOR_ID, AUDIOVOX_PRODUCT_AIRCARD) },

{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID,NOVATELWIRELESS_PRODUCT_U740) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ID) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
 	{ } /* Terminating entry */
 };
 
@@ -112,6 +117,8 @@ static struct usb_device_id option_ids1[
 	{ USB_DEVICE(AUDIOVOX_VENDOR_ID, AUDIOVOX_PRODUCT_AIRCARD) },

{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID,NOVATELWIRELESS_PRODUCT_U740) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ID) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
 	{ } /* Terminating entry */
 };

===================================================================

-
Leon Leong
upleong@bandrich.com


