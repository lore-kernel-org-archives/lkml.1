Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZCTXWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZCTXWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbZCTXOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:14:00 -0400
Received: from kroah.org ([198.145.64.141]:53251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754258AbZCTXN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:12 2009
Message-Id: <20090320222712.775232248@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:35 -0700
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
       alan@lxorguk.ukuu.org.uk, Achilleas Kotsis <akots@exponent.gr>
Subject: [patch 24/32] USB: Add device id for Option GTM380 to option driver
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=usb-add-device-id-for-option-gtm380-to-option-driver.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Achilleas Kotsis <akots@exponent.gr>

commit e7f2f0d77a7b483a26054f29ba8393831b25a8a4 upstream.

Option GTM380 in Modem mode uses Product ID 0x7201. This has been tested and works
on production systems for over 6 months.

Signed-off-by: Achilleas Kotsis <akots@exponent.gr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -89,6 +89,7 @@ static int  option_send_setup(struct tty
 #define OPTION_PRODUCT_ETNA_MODEM_GT		0x7041
 #define OPTION_PRODUCT_ETNA_MODEM_EX		0x7061
 #define OPTION_PRODUCT_ETNA_KOI_MODEM		0x7100
+#define OPTION_PRODUCT_GTM380_MODEM		0x7201
 
 #define HUAWEI_VENDOR_ID			0x12D1
 #define HUAWEI_PRODUCT_E600			0x1001
@@ -319,6 +320,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM_GT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM_EX) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
+	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GTM380_MODEM) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },


