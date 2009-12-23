Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZLWI5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZLWI5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZLWI5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:57:34 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58841 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZLWI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:57:32 -0500
Message-Id: <20091223085552.509728539@vergenet.net>
User-Agent: quilt/0.48-1
Date: Wed, 23 Dec 2009 19:54:51 +1100
Subject: [patch 3/7] [patch] rt2870: Remove unnecessary forward declarations
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Simon Horman <horms@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
Content-Disposition: inline; filename=rt2870-static.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary forward declaration of rtusb_probe() and rtusb_disconnect()

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/rt2860/usb_main_dev.c
===================================================================
--- linux-2.6.orig/drivers/staging/rt2860/usb_main_dev.c	2009-12-23 11:24:57.000000000 +1100
+++ linux-2.6/drivers/staging/rt2860/usb_main_dev.c	2009-12-23 11:25:06.000000000 +1100
@@ -216,10 +216,6 @@ static int rt2870_suspend(struct usb_int
 static int rt2870_resume(struct usb_interface *intf);
 #endif /* CONFIG_PM // */
 
-static int rtusb_probe(struct usb_interface *intf,
-		       const struct usb_device_id *id);
-static void rtusb_disconnect(struct usb_interface *intf);
-
 static BOOLEAN USBDevConfigInit(IN struct usb_device *dev,
 				IN struct usb_interface *intf,
 				struct rt_rtmp_adapter *pAd)

