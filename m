Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbYLKT3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbYLKT3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbYLKTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:38 -0500
Received: from kroah.org ([198.145.64.141]:56127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757476AbYLKTSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:32 -0500
Date: Thu, 11 Dec 2008 11:14:45 -0800
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
       alan@lxorguk.ukuu.org.uk, Domenico Riccio <domenico.riccio@gmail.com>
Subject: [patch 33/83] USB: serial: add more Onda device ids to option
	driver
Message-ID: <20081211191445.GG5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-serial-add-more-onda-device-ids-to-option-driver.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 5bb4bd9895df508ed2bd8b3280252d8a8170e4ac upstream.

Thanks to Domenico Riccio for pointing these out.

Cc: Domenico Riccio <domenico.riccio@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -224,6 +224,7 @@ static int  option_send_setup(struct tty
 #define ONDA_VENDOR_ID				0x19d2
 #define ONDA_PRODUCT_MSA501HS			0x0001
 #define ONDA_PRODUCT_ET502HS			0x0002
+#define ONDA_PRODUCT_MT503HS			0x0200
 
 #define BANDRICH_VENDOR_ID			0x1A8D
 #define BANDRICH_PRODUCT_C100_1			0x1002
@@ -413,6 +414,40 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(AXESSTEL_VENDOR_ID, AXESSTEL_PRODUCT_MV110H) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_MSA501HS) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0003) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0004) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0005) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0006) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0007) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0008) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0009) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x000a) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x000b) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x000c) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x000d) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x000e) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x000f) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0010) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0011) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0012) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0013) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0014) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0015) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0016) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0017) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0018) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0019) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0020) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0021) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0022) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0023) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0024) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0025) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0026) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0027) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0028) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0029) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_MT503HS) },
 	{ USB_DEVICE(YISO_VENDOR_ID, YISO_PRODUCT_U893) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },

