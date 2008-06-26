Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYFZQOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYFZQOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYFZQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:14:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46666 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYFZQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:14:06 -0400
Subject: [PATCH] option: Remove duplicate device entry
From: Ben Collins <ben.collins@canonical.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 12:00:19 -0400
Message-Id: <1214496019.7150.17.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 43cfde8..efb1ea9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -190,9 +190,6 @@ static int  option_send_setup(struct usb_serial_port *port);
 #define BANDRICH_PRODUCT_C100_1			0x1002
 #define BANDRICH_PRODUCT_C100_2			0x1003
 
-#define AMOI_VENDOR_ID			0x1614
-#define AMOI_PRODUCT_9508			0x0800
-
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define MAXON_VENDOR_ID				0x16d8
@@ -255,7 +252,6 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1417, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1418, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1419, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V740) }, /* Novatel Merlin EX720/V740/X720 */


