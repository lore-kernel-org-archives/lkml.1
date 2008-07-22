Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYGVH21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYGVH21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 03:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYGVH2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 03:28:19 -0400
Received: from vuizook.err.no ([194.24.252.247]:52272 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYGVH2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 03:28:18 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 03:28:18 EDT
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pl2023: Remove USB id (4348:5523) handled by ch341
Mail-Copies-To: never
From: Tollef Fog Heen <tfheen@err.no>
Date: Tue, 22 Jul 2008 09:28:05 +0200
Message-ID: <871w1mwf7e.fsf@xoog.err.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch against current git as of last night (so 2.6.26)

USB ID 4348:5523 is handled by the ch341 driver.  Remove it from the
pl2023 driver.

Reverts 002e8f2c80c6be76bb312940bc278fc10b2b2487.

Signed-off-by: Tollef Fog Heen <tfheen@err.no>

---

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 2a0dd1b..63287ad 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -89,7 +89,6 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(ALCOR_VENDOR_ID, ALCOR_PRODUCT_ID) },
 	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
-	{ USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
 	{ USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 6ac3bbc..a3bd039 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -107,10 +107,6 @@
 #define COREGA_VENDOR_ID	0x07aa
 #define COREGA_PRODUCT_ID	0x002a
 
-/* HL HL-340 (ID: 4348:5523) */
-#define HL340_VENDOR_ID		0x4348
-#define HL340_PRODUCT_ID	0x5523
-
 /* Y.C. Cable U.S.A., Inc - USB to RS-232 */
 #define YCCABLE_VENDOR_ID	0x05ad
 #define YCCABLE_PRODUCT_ID	0x0fba


-- 
Tollef Fog Heen
UNIX is user friendly, it's just picky about who its friends are
