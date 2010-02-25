Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0BYLjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:39:19 -0500
Received: from newyear.aktivix.org ([209.234.249.206]:42541 "EHLO
	newyear.aktivix.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab0BYLjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:39:18 -0500
From: Jim Dog <jimdog@northern-indymedia.org>
To: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com,
       richard@rsk.demon.co.uk, jimdog@northern-indymedia.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: wlan-ng: Fixed line length issues in prism2usb.c This is a patch to the prism2usb.c that fixes one line which was over the 80 character limit by wrapping it to a new line and removes a commented out configuration for a ZyDAS ZD1201 device since support for this device with this driver is now deprecated. Signed-off-by: Jim Dog <jimdog@northern-indymedia.org>
Date: Thu, 25 Feb 2010 11:38:21 +0000
Message-Id: <1267097901-8574-1-git-send-email-jimdog@northern-indymedia.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/wlan-ng/prism2usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 9dde68b..501d27f 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -24,8 +24,9 @@ static struct usb_device_id usb_prism_tbl[] = {
 	 (0x066b, 0x2213, "Linksys WUSB12v1.1 11Mbps WLAN USB Adapter")},
 	{PRISM_USB_DEVICE
 	 (0x067c, 0x1022, "Siemens SpeedStream 1022 11Mbps WLAN USB Adapter")},
-	{PRISM_USB_DEVICE(0x049f, 0x0033,
-			  "Compaq/Intel W100 PRO/Wireless 11Mbps multiport WLAN Adapter")},
+	{PRISM_USB_DEVICE
+	 (0x049f, 0x0033,
+	 "Compaq/Intel W100 PRO/Wireless 11Mbps multiport WLAN Adapter")},
 	{PRISM_USB_DEVICE
 	 (0x0411, 0x0016, "Melco WLI-USB-S11 11Mbps WLAN Adapter")},
 	{PRISM_USB_DEVICE
@@ -55,7 +56,6 @@ static struct usb_device_id usb_prism_tbl[] = {
 	 (0x04f1, 0x3009, "JVC MP-XP7250 Builtin USB WLAN Adapter")},
 	{PRISM_USB_DEVICE(0x0846, 0x4110, "NetGear MA111")},
 	{PRISM_USB_DEVICE(0x03f3, 0x0020, "Adaptec AWN-8020 USB WLAN Adapter")},
-/*      {PRISM_USB_DEVICE(0x0ace, 0x1201, "ZyDAS ZD1201 Wireless USB Adapter")}, */
 	{PRISM_USB_DEVICE(0x2821, 0x3300, "ASUS-WL140 Wireless USB Adapter")},
 	{PRISM_USB_DEVICE(0x2001, 0x3700, "DWL-122 Wireless USB Adapter")},
 	{PRISM_USB_DEVICE
-- 
1.6.3.3

