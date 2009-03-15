Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZCOBdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZCOBdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 21:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZCOBdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 21:33:32 -0400
Received: from b01.ext.isohunt.com ([208.71.112.51]:55597 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbZCOBdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 21:33:31 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2009 21:33:31 EDT
From: "Robin H\. Johnson" <robbat2@orbis-terrarum.net>
To: laurent.pinchart@skynet.be
Cc: linux-kernel@vger.kernel.org,
       "Robin H\. Johnson" <robbat2@orbis-terrarum.net>
Subject: [PATCH UVC] Add UVC entry for Logitech Quickcam Orbit AF.
Date: Sat, 14 Mar 2009 18:26:45 -0700
Message-Id: <1237080405-13437-1-git-send-email-robbat2@orbis-terrarum.net>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need explicit entry like many of the other Logitech devices as it does
not match the class otherwise.

Signed-off-by: Robin H. Johnson <robbat2@orbis-terrarum.net>
---
 drivers/media/video/uvc/uvc_driver.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b128732..f5e76c8 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1801,6 +1801,14 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0 },
+	/* Logitech Quickcam Orbit AF */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0994,
+	  .bInterfaceClass	= USB_CLASS_VENDOR_SPEC,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0 },
 	/* Logitech Quickcam Pro for Notebook */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.6.2

