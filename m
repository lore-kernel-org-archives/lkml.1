Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYF0AI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYF0AI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYF0AIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:08:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34281 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYF0AIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:08:17 -0400
Subject: [PATCH] keyspan: Remove duplicate device entries
From: Ben Collins <ben.collins@canonical.com>
To: gregkh <gregkh@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 20:08:16 -0400
Message-Id: <1214525296.7150.120.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 28xb, as documented in comments, has the same ID's as the 28x.
Remove the duplicated ID's from the device tables, and expand the
comment to document this.

Signed-off-by: Ben Collins <ben.collins@canonical.com>
CC: Greg Kroah-Hartman <greg@kroah.com>

diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
index 8d6ed02..cc48512 100644
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -222,7 +222,8 @@ struct ezusb_hex_record {
 
 /* Product IDs post-renumeration.  Note that the 28x and 28xb
    have the same id's post-renumeration but behave identically
-   so it's not an issue. */
+   so it's not an issue. As such, the 28xb is not listed in any
+   of the device tables. */
 #define	keyspan_usa18x_product_id		0x0112
 #define	keyspan_usa19_product_id		0x0107
 #define	keyspan_usa19qi_product_id		0x010c
@@ -566,7 +567,6 @@ static struct usb_device_id keyspan_ids_combined[] = {
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28_product_id) },
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28x_product_id) },
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28xa_product_id) },
-	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28xb_product_id) },
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28xg_product_id) },
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa49w_product_id)},
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa49wlc_product_id)},
@@ -616,7 +616,6 @@ static struct usb_device_id keyspan_2port_ids[] = {
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28_product_id) },
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28x_product_id) },
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28xa_product_id) },
-	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28xb_product_id) },
 	{ USB_DEVICE(KEYSPAN_VENDOR_ID, keyspan_usa28xg_product_id) },
 	{ } /* Terminating entry */
 };


