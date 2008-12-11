Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbYLKT10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbYLKT10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYLKTSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:31 -0500
Received: from kroah.org ([198.145.64.141]:56039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757476AbYLKTSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:22 -0500
Date: Thu, 11 Dec 2008 11:14:28 -0800
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
Subject: [patch 26/83] USB: option: add Ericsson F3507g and Dell 5530
Message-ID: <20081211191428.GZ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-option-add-ericsson-f3507g-and-dell-5530.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit b064eca9b0cdbb2b8f731ae2e44fa02194a1219a upstream.

Add a few more mobile broadband cards.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -220,6 +220,10 @@ static int  option_send_setup(struct tty
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
 
+/* Ericsson products */
+#define ERICSSON_VENDOR_ID			0x0bdb
+#define ERICSSON_PRODUCT_F3507G			0x1900
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -318,6 +322,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8136) },	/* Dell Wireless HSDPA 5520 == Novatel Expedite EU860D */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8137) },	/* Dell Wireless HSDPA 5520 */
 	{ USB_DEVICE(DELL_VENDOR_ID, 0x8138) },	/* Dell Wireless 5520 Voda I Mobile Broadband (3G HSDPA) Minicard */
+	{ USB_DEVICE(DELL_VENDOR_ID, 0x8147) },	/* Dell Wireless 5530 Mobile Broadband (3G HSPA) Mini-Card */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
@@ -349,6 +354,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
+	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

