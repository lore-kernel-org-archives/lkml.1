Return-Path: <linux-kernel-owner+w=401wt.eu-S1763873AbZCTXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763873AbZCTXeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762995AbZCTXYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:42 -0400
Received: from kroah.org ([198.145.64.141]:48671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762978AbZCTXYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:26 2009
Message-Id: <20090320222926.575954209@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:33 -0700
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
       alan@lxorguk.ukuu.org.uk, Dirk Hohndel <hohndel@infradead.org>
Subject: [patch 23/43] USB: Add Vendor/Product ID for new CDMA U727 to option driver
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-add-vendor-product-id-for-new-cdma-u727-to-option-driver.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dirk Hohndel <hohndel@infradead.org>

commit 56a21827439a4d715b510bfaf488534e6f4ad2f8 upstream.

* newer versions of the Novatel Wireless U727 CDMA 3G USB stick
   have a different Product ID (0x5010); adding this ID makes them
   work just fine with the option driver

Signed-off-by: Dirk Hohndel <hohndel@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -190,6 +190,7 @@ static int  option_send_setup(struct tty
 /* OVATION PRODUCTS */
 #define NOVATELWIRELESS_PRODUCT_MC727		0x4100
 #define NOVATELWIRELESS_PRODUCT_MC950D		0x4400
+#define NOVATELWIRELESS_PRODUCT_U727		0x5010
 
 /* FUTURE NOVATEL PRODUCTS */
 #define NOVATELWIRELESS_PRODUCT_EVDO_FULLSPEED	0X6000
@@ -402,6 +403,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EU870D) }, /* Novatel EU850D/EU860D/EU870D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC950D) }, /* Novatel MC930D/MC950D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC727) }, /* Novatel MC727/U727/USB727 */
+	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U727) }, /* Novatel MC727/U727/USB727 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_FULLSPEED) }, /* Novatel EVDO product */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_FULLSPEED) }, /* Novatel HSPA product */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) }, /* Novatel EVDO Embedded product */


