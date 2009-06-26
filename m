Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbZFZOK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbZFZOK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZFZOKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:10:19 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:55515 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbZFZOKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:10:18 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-usb@vger.kernel.org
Subject: [PATCH] usb: add missing class descriptions used in usb/devices file
Date: Fri, 26 Jun 2009 16:10:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906261610.20075.elendil@planet.nl>
X-OriginalArrivalTime: 26 Jun 2009 14:10:20.0865 (UTC) FILETIME=[D7296B10:01C9F667]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added descriptions (for WIRELESS_CONTROLLER and MISC) were taken from
the usb-devices script now included in usbutils.

Also sort the classes in the same order as in include/linux/usb/ch9.h
for easier comparison for future updates.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 73c108d..96f1171 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -136,17 +136,19 @@ static const struct class_info clas_info[] =
 	{USB_CLASS_AUDIO,		"audio"},
 	{USB_CLASS_COMM,		"comm."},
 	{USB_CLASS_HID,			"HID"},
-	{USB_CLASS_HUB,			"hub"},
 	{USB_CLASS_PHYSICAL,		"PID"},
+	{USB_CLASS_STILL_IMAGE,		"still"},
 	{USB_CLASS_PRINTER,		"print"},
 	{USB_CLASS_MASS_STORAGE,	"stor."},
+	{USB_CLASS_HUB,			"hub"},
 	{USB_CLASS_CDC_DATA,		"data"},
-	{USB_CLASS_APP_SPEC,		"app."},
-	{USB_CLASS_VENDOR_SPEC,		"vend."},
-	{USB_CLASS_STILL_IMAGE,		"still"},
 	{USB_CLASS_CSCID,		"scard"},
 	{USB_CLASS_CONTENT_SEC,		"c-sec"},
 	{USB_CLASS_VIDEO,		"video"},
+	{USB_CLASS_WIRELESS_CONTROLLER,	"wlcon"},
+	{USB_CLASS_MISC,		"misc"},
+	{USB_CLASS_APP_SPEC,		"app."},
+	{USB_CLASS_VENDOR_SPEC,		"vend."},
 	{-1,				"unk."}		/* leave as last */
 };
 
