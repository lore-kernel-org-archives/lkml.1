Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZG2AC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZG2AC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZG2ACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:02:10 -0400
Received: from kroah.org ([198.145.64.141]:35664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZG1Xtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:53 2009
Message-Id: <20090728234152.889164450@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 11/71] USB: ti_usb_3410_5052: fix duplicate device ids.
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=usb-ti_usb_3410_5052-fix-duplicate-device-ids.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 3c43f27bf57b0502df2478253699559ee1d43f6d upstream.

commit 1a1fab513734b3a4fca1bee8229e5ff7e1cb873c accidentally added the
device id to both tables in the driver, which causes problems as this is
only a single port device, not a multiple port device.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -192,7 +192,6 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5152_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_EEPROM_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
-	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 };
 
 static struct usb_device_id ti_id_table_combined[14+2*TI_EXTRA_VID_PID_COUNT+1] = {


