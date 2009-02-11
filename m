Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbZBKAqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbZBKAqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbZBKA2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:55 -0500
Received: from kroah.org ([198.145.64.141]:51638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757899AbZBKA2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:53 -0500
Date: Tue, 10 Feb 2009 16:25:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [patch 51/56] USB: new id for ti_usb_3410_5052 driver
Message-ID: <20090211002559.GZ14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-new-id-for-ti_usb_3410_5052-driver.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Oliver Neukum <oliver@neukum.org>

commit 1a1fab513734b3a4fca1bee8229e5ff7e1cb873c upstream.

This adds a new device id

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    3 +++
 drivers/usb/serial/ti_usb_3410_5052.h |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -230,6 +230,7 @@ static unsigned int product_5052_count;
 static struct usb_device_id ti_id_table_3410[1+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 };
 
 static struct usb_device_id ti_id_table_5052[4+TI_EXTRA_VID_PID_COUNT+1] = {
@@ -237,6 +238,7 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5152_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_EEPROM_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 };
 
 static struct usb_device_id ti_id_table_combined[] = {
@@ -246,6 +248,7 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5152_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_EEPROM_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ }
 };
 
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -27,7 +27,9 @@
 
 /* Vendor and product ids */
 #define TI_VENDOR_ID			0x0451
+#define IBM_VENDOR_ID			0x04b3
 #define TI_3410_PRODUCT_ID		0x3410
+#define IBM_4543_PRODUCT_ID		0x4543
 #define TI_3410_EZ430_ID		0xF430  /* TI ez430 development tool */
 #define TI_5052_BOOT_PRODUCT_ID		0x5052	/* no EEPROM, no firmware */
 #define TI_5152_BOOT_PRODUCT_ID		0x5152	/* no EEPROM, no firmware */

