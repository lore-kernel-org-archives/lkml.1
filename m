Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZBJTVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZBJTVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZBJTEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:25 -0500
Received: from kroah.org ([198.145.64.141]:33907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755852AbZBJTEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:21 -0500
Date: Tue, 10 Feb 2009 11:01:33 -0800
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
       alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>,
       Chris Adams <cmadams@hiwaay.net>
Subject: [patch 49/53] USB: two more usb ids for ti_usb_3410_5052
Message-ID: <20090210190133.GX14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-two-more-usb-ids-for-ti_usb_3410_5052.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Oliver Neukum <oliver@neukum.org>

commit 97dcf0416e390fc5c997d4ea60e6f975c7b7a1c3 upstream.

This patch adds device IDs and balances the counts to make the
hot ID additioning mechanism work.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: Chris Adams <cmadams@hiwaay.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ti_usb_3410_5052.c |   10 +++++++---
 drivers/usb/serial/ti_usb_3410_5052.h |    2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -176,13 +176,15 @@ static unsigned int product_5052_count;
 /* the array dimension is the number of default entries plus */
 /* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
 /* null entry */
-static struct usb_device_id ti_id_table_3410[1+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_3410[10+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 };
 
-static struct usb_device_id ti_id_table_5052[4+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5152_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_EEPROM_PRODUCT_ID) },
@@ -190,7 +192,7 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 };
 
-static struct usb_device_id ti_id_table_combined[] = {
+static struct usb_device_id ti_id_table_combined[14+2*TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_BOOT_PRODUCT_ID) },
@@ -198,6 +200,8 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_EEPROM_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ }
 };
 
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -30,6 +30,8 @@
 #define IBM_VENDOR_ID			0x04b3
 #define TI_3410_PRODUCT_ID		0x3410
 #define IBM_4543_PRODUCT_ID		0x4543
+#define IBM_454B_PRODUCT_ID		0x454b
+#define IBM_454C_PRODUCT_ID		0x454c
 #define TI_3410_EZ430_ID		0xF430  /* TI ez430 development tool */
 #define TI_5052_BOOT_PRODUCT_ID		0x5052	/* no EEPROM, no firmware */
 #define TI_5152_BOOT_PRODUCT_ID		0x5152	/* no EEPROM, no firmware */

