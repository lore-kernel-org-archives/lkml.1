Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbYLKT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbYLKT3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbYLKTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:37 -0500
Received: from kroah.org ([198.145.64.141]:56117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757578AbYLKTSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:30 -0500
Date: Thu, 11 Dec 2008 11:14:43 -0800
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
       alan@lxorguk.ukuu.org.uk, Leslie Harlley Watter <leslie@watter.org>
Subject: [patch 32/83] USB: Add YISO u893 usb modem vendor and product IDs
	to option driver
Message-ID: <20081211191443.GF5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-add-yiso-u893-usb-modem-vendor-and-product-ids-to-option-driver.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Leslie Watter <leslie.watter@gmail.com>

commit c6206faa4f18bcc837a12552b8c184ab1668fdea upstream

This patch adds YISO u893 usb modem vendor and product ID to option.c.

I had a better experience using this modification and the same system.

Signed-off-by: Leslie Harlley Watter <leslie@watter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -160,6 +160,11 @@ static int  option_send_setup(struct tty
 
 #define NOVATELWIRELESS_VENDOR_ID		0x1410
 
+/* YISO PRODUCTS */
+
+#define YISO_VENDOR_ID				0x0EAB
+#define YISO_PRODUCT_U893			0xC893
+
 /* MERLIN EVDO PRODUCTS */
 #define NOVATELWIRELESS_PRODUCT_V640		0x1100
 #define NOVATELWIRELESS_PRODUCT_V620		0x1110
@@ -408,6 +413,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(AXESSTEL_VENDOR_ID, AXESSTEL_PRODUCT_MV110H) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_MSA501HS) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
+	{ USB_DEVICE(YISO_VENDOR_ID, YISO_PRODUCT_U893) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1004) },

