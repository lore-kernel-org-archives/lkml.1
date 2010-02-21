Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0BUPb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 10:31:59 -0500
Received: from newyear.aktivix.org ([209.234.249.206]:35653 "EHLO
	newyear.aktivix.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0BUPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 10:31:57 -0500
X-Greylist: delayed 1627 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 10:31:57 EST
From: jimdog@northern-indymedia.org
To: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com,
       richard@rsk.demon.co.uk, jimdog@northern-indymedia.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: wlan-ng: Fix 80 character limit warnings Fixed 2 warnings identified by the checkpatch.pl tool which occured due to two lines of code going over the 80 character limit. Fixed by wrapping the lines. Signed-off-by: Jim Dog <jimdog@northern-indymedia.org>
Date: Sun, 21 Feb 2010 15:03:51 +0000
Message-Id: <1266764631-26486-1-git-send-email-jimdog@northern-indymedia.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Dog <jimdog@northern-indymedia.org>

---
 drivers/staging/wlan-ng/prism2usb.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index 9dde68b..b55930c 100644
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
+	  "Compaq/Intel W100 PRO/Wireless 11Mbps multiport WLAN Adapter")},
 	{PRISM_USB_DEVICE
 	 (0x0411, 0x0016, "Melco WLI-USB-S11 11Mbps WLAN Adapter")},
 	{PRISM_USB_DEVICE
@@ -55,7 +56,9 @@ static struct usb_device_id usb_prism_tbl[] = {
 	 (0x04f1, 0x3009, "JVC MP-XP7250 Builtin USB WLAN Adapter")},
 	{PRISM_USB_DEVICE(0x0846, 0x4110, "NetGear MA111")},
 	{PRISM_USB_DEVICE(0x03f3, 0x0020, "Adaptec AWN-8020 USB WLAN Adapter")},
-/*      {PRISM_USB_DEVICE(0x0ace, 0x1201, "ZyDAS ZD1201 Wireless USB Adapter")}, */
+/*
+	{PRISM_USB_DEVICE(0x0ace, 0x1201, "ZyDAS ZD1201 Wireless USB Adapter")},
+*/
 	{PRISM_USB_DEVICE(0x2821, 0x3300, "ASUS-WL140 Wireless USB Adapter")},
 	{PRISM_USB_DEVICE(0x2001, 0x3700, "DWL-122 Wireless USB Adapter")},
 	{PRISM_USB_DEVICE
-- 
1.6.3.3

