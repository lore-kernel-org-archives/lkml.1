Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZJVHAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZJVHAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZJVHAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:00:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47462 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZJVHAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:00:46 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: smurf@smurf.noris.de
Cc: linux-usb@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] UBUNTU: USB: option: TLAYTECH TUE800 support
Date: Thu, 22 Oct 2009 15:00:36 +0800
Message-Id: <1256194836-15733-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ID for Tlaytech TUE800 CDMA modem to the option driver.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/usb/serial/option.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 6d46d3f..dfd8409 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -325,6 +325,9 @@ static int  option_resume(struct usb_serial *serial);
 #define ALCATEL_VENDOR_ID			0x1bbb
 #define ALCATEL_PRODUCT_X060S			0x0000
 
+/* TLAYTECH PRODUCTS */
+#define TLAYTECH_VENDOR_ID			0x20B9
+#define TLAYTECH_PRODUCT_TEU800			0x1682
 
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
@@ -584,6 +587,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
+	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.6.3.3

