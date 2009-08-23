Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbZHWN32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbZHWN32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933918AbZHWN30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891AbZHWN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dRlQg/nwIAltpxAc2x/42S6ytKGMP3MYEiW83TGUWpiP9LZES9t+OGbkou6KZM6dyn
         zJKIvB46gWHd/9/DCKe+IdnqT/ETikWP3wrN45HowEKSQNEDUAg8I55duO1gfx+Szch1
         IPD3bo1JMFMv9OIDWupBaeKFyvTHjT2TXqeGM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:51 +0200
Message-Id: <20090823132951.17784.12331.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/33] Staging: rt3070: add remaining rt2870 device ids
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: add remaining rt2870 device ids

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2870/2870_main_dev.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

Index: b/drivers/staging/rt2870/2870_main_dev.c
===================================================================
--- a/drivers/staging/rt2870/2870_main_dev.c
+++ b/drivers/staging/rt2870/2870_main_dev.c
@@ -61,10 +61,8 @@ extern INT __devinit rt28xx_probe(IN voi
 
 struct usb_device_id rtusb_usb_id[] = {
 	{ USB_DEVICE(0x148F, 0x2770) }, /* Ralink */
-#ifndef RT30xx
 	{ USB_DEVICE(0x1737, 0x0071) }, /* Linksys WUSB600N */
 	{ USB_DEVICE(0x1737, 0x0070) }, /* Linksys */
-#endif
 	{ USB_DEVICE(0x148F, 0x2870) }, /* Ralink */
 	{ USB_DEVICE(0x148F, 0x3070) }, /* Ralink 3070 */
 #ifdef RT30xx
@@ -82,15 +80,11 @@ struct usb_device_id rtusb_usb_id[] = {
 #endif
 	{ USB_DEVICE(0x0DF6, 0x002D) }, /* Sitecom */
 	{ USB_DEVICE(0x0DF6, 0x0039) }, /* Sitecom 2770 */
-#ifndef RT30xx
 	{ USB_DEVICE(0x0DF6, 0x003F) }, /* Sitecom WL-608 */
-#endif
 	{ USB_DEVICE(0x14B2, 0x3C06) }, /* Conceptronic */
 	{ USB_DEVICE(0x14B2, 0x3C28) }, /* Conceptronic */
 	{ USB_DEVICE(0x2019, 0xED06) }, /* Planex Communications, Inc. */
-#ifndef RT30xx
 	{ USB_DEVICE(0x2019, 0xED14) }, /* Planex Communications, Inc. */
-#endif
 	{ USB_DEVICE(0x2019, 0xAB25) }, /* Planex Communications, Inc. RT3070 */
 	{ USB_DEVICE(0x07D1, 0x3C09) }, /* D-Link */
 	{ USB_DEVICE(0x07D1, 0x3C11) }, /* D-Link */
@@ -101,10 +95,8 @@ struct usb_device_id rtusb_usb_id[] = {
 	{ USB_DEVICE(0x14B2, 0x3C07) }, /* AL */
 	{ USB_DEVICE(0x14B2, 0x3C12) }, /* AL 3070 */
 	{ USB_DEVICE(0x050D, 0x8053) }, /* Belkin */
-#ifndef RT30xx
 	{ USB_DEVICE(0x050D, 0x815C) }, /* Belkin */
 	{ USB_DEVICE(0x050D, 0x825a) }, /* Belkin */
-#endif
 	{ USB_DEVICE(0x14B2, 0x3C23) }, /* Airlink */
 	{ USB_DEVICE(0x14B2, 0x3C27) }, /* Airlink */
 	{ USB_DEVICE(0x07AA, 0x002F) }, /* Corega */
@@ -152,10 +144,9 @@ struct usb_device_id rtusb_usb_id[] = {
 	{ USB_DEVICE(0x04E8, 0x2018) }, /* samsung */
 	{ USB_DEVICE(0x07B8, 0x3070) }, /* AboCom 3070 */
 	{ USB_DEVICE(0x07B8, 0x3071) }, /* AboCom 3071 */
-#ifndef RT30xx
 	{ USB_DEVICE(0x07B8, 0x2870) }, /* AboCom */
 	{ USB_DEVICE(0x07B8, 0x2770) }, /* AboCom */
-#else
+#ifdef RT30xx
 	{ USB_DEVICE(0x07B8, 0x3072) }, /* Abocom 3072 */
 #endif
 	{ USB_DEVICE(0x7392, 0x7711) }, /* Edimax 3070 */
@@ -167,9 +158,8 @@ struct usb_device_id rtusb_usb_id[] = {
 	{ USB_DEVICE(0x0789, 0x0162) }, /* Logitec 2870 */
 	{ USB_DEVICE(0x0789, 0x0163) }, /* Logitec 2870 */
 	{ USB_DEVICE(0x0789, 0x0164) }, /* Logitec 2870 */
-#ifndef RT30xx
 	{ USB_DEVICE(0x7392, 0x7717) }, /* Edimax */
-#else
+#ifdef RT30xx
 	{ USB_DEVICE(0x1EDA, 0x2310) }, /* AirTies 3070 */
 	{ USB_DEVICE(0x1737, 0x0077) }, /* Linksys WUSB54GC-EU v3 */
 #endif
