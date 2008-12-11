Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbYLKT22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbYLKT22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYLKTSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:34 -0500
Received: from kroah.org ([198.145.64.141]:56073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757553AbYLKTS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:26 -0500
Date: Thu, 11 Dec 2008 11:14:37 -0800
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
       alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>
Subject: [patch 29/83] USB: option: add Pantech cards
Message-ID: <20081211191437.GC5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-option-add-pantech-cards.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 8b6346ec899713a90890c9e832f7eff91ea73504 upstream

Add some Pantech mobile broadband IDs.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/option.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -213,6 +213,12 @@ static int  option_send_setup(struct tty
 #define ERICSSON_VENDOR_ID			0x0bdb
 #define ERICSSON_PRODUCT_F3507G			0x1900
 
+/* Pantech products */
+#define PANTECH_VENDOR_ID			0x106c
+#define PANTECH_PRODUCT_PC5740			0x3701
+#define PANTECH_PRODUCT_PC5750			0x3702  /* PX-500 */
+#define PANTECH_PRODUCT_UM150			0x3711
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -333,6 +339,9 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
 	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G) },
+	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_PC5740) },
+	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_PC5750) },
+	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_UM150) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

