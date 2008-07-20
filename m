Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbYGUEnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbYGUEnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYGUEnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:43:08 -0400
Received: from www.swissdisk.com ([216.66.254.197]:47230 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYGUEnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:43:06 -0400
X-Greylist: delayed 2911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 00:43:06 EDT
From: Alexandre Karpenko <alexander@comm.utoronto.ca>
Date: Sun, 20 Jul 2008 17:44:55 -0400
Subject: [PATCH 7/7] HID: Add quirks for fourth generation MacBooks (4,1)
To: linux-kernel@vger.kernel.org
In-Reply-To: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
CC: linux-usb@vger.kernel.org
Message-Id: <E1KKl4J-00068Z-9g@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference: https://launchpad.net/bugs/207127

Added device ids to hid-quriks for detection of keyboards on 4th generation
Macbook Pro and Macbook Air.

CC: linux-usb@vger.kernel.org
Signed-off-by: Alexandre Karpenko <alexander@comm.utoronto.ca>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
---
 drivers/hid/usbhid/hid-quirks.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 1df832a..8cf16e9 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -75,6 +75,12 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI	0x0223
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ISO	0x0224
+#define USB_DEVICE_ID_APPLE_WELLSPRING_JIS	0x0225
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
@@ -644,7 +650,12 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI, HID_QUIRK_APPLE_HAS_FN },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS, HID_QUIRK_APPLE_HAS_FN },
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_HARMONY, HID_QUIRK_IGNORE },
-- 
1.5.4.3

