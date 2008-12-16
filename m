Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbYLPU26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbYLPU26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758999AbYLPU2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:28:23 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:16291 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007AbYLPU2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:28:22 -0500
Subject: [PATCH] pl2303: add id for Hewlett-Packard LD220-HP POS pole
	display
From: Mike Provencher <mike.provencher@hp.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Tue, 16 Dec 2008 14:30:14 -0600
Message-Id: <1229459414.4871.91.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add id for the Hewlett-Packard LD220-HP POS pole display.

Bus 002 Device 002: ID 03f0:3524 Hewlett-Packard

Signed-off-by: Mike Provencher <mike.provencher@hp.com>

 pl2303.c |    1 +
 pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.h       2008-12-16 10:40:41.000000000 -0600
+++ b/drivers/usb/serial/pl2303.h       2008-12-16 14:03:18.000000000 -0600
@@ -110,3 +110,7 @@
 /* Y.C. Cable U.S.A., Inc - USB to RS-232 */
 #define YCCABLE_VENDOR_ID      0x05ad
 #define YCCABLE_PRODUCT_ID     0x0fba
+
+/* Hewlett-Packard LD220-HP POS Pole Display */
+#define HP_VENDOR_ID           0x03f0
+#define HP_LD220_PRODUCT_ID    0x3524

--- a/drivers/usb/serial/pl2303.c       2008-12-16 10:40:41.000000000 -0600
+++ b/drivers/usb/serial/pl2303.c       2008-12-16 10:48:09.000000000 -0600
@@ -91,6 +91,7 @@ static struct usb_device_id id_table [] 
        { USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
        { USB_DEVICE(COREGA_VENDOR_ID, COREGA_PRODUCT_ID) },
        { USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
+       { USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
        { }                                     /* Terminating entry */
 };



