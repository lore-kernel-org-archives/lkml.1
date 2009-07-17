Return-Path: <linux-kernel-owner+w=401wt.eu-S934677AbZGQNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbZGQNzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934636AbZGQNzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:55:40 -0400
Received: from mail.tpi.com ([70.99.223.143]:2386 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934589AbZGQNzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:55:40 -0400
To: smurf@smurf.noris.de
Subject: [PATCH] USB Option driver - Add USB ID for Novatel MC727/U727/USB727 refresh
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Message-Id: <20090717135536.192B4F8911@sepang.rtg.net>
Date: Fri, 17 Jul 2009 07:55:36 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0ce30b61f23e284d239ee140ae77cd100991ae94 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Fri, 17 Jul 2009 07:46:20 -0600
Subject: [PATCH] USB Option driver - Add USB ID for Novatel MC727/U727/USB727 refresh

BugLink: https://bugs.launchpad.net/bugs/365291

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/usb/serial/option.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 30ddbbe..3ae60bd 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -205,6 +205,7 @@ static int  option_resume(struct usb_serial *serial);
 #define NOVATELWIRELESS_PRODUCT_MC727		0x4100
 #define NOVATELWIRELESS_PRODUCT_MC950D		0x4400
 #define NOVATELWIRELESS_PRODUCT_U727		0x5010
+#define NOVATELWIRELESS_PRODUCT_MC727_NEW	0x5100
 #define NOVATELWIRELESS_PRODUCT_MC760		0x6000
 #define NOVATELWIRELESS_PRODUCT_OVMC760		0x6002
 
@@ -436,6 +437,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EU870D) }, /* Novatel EU850D/EU860D/EU870D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC950D) }, /* Novatel MC930D/MC950D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC727) }, /* Novatel MC727/U727/USB727 */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC727_NEW) }, /* Novatel MC727/U727/USB727 refresh */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U727) }, /* Novatel MC727/U727/USB727 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC760) }, /* Novatel MC760/U760/USB760 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_OVMC760) }, /* Novatel Ovation MC760 */
-- 
1.6.2.4

