Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbZCTXem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbZCTXem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763001AbZCTXYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:43 -0400
Received: from kroah.org ([198.145.64.141]:48684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762969AbZCTXYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:26 2009
Message-Id: <20090320222926.721059657@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:34 -0700
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
       alan@lxorguk.ukuu.org.uk, Albert Pauw <albert.pauw@gmail.com>
Subject: [patch 24/43] USB: option.c: add ZTE 622 modem device
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-option.c-add-zte-622-modem-device.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Albert Pauw <albert.pauw@gmail.com>

commit 9ea19b82f3126da4e47d6b94563a3c2cd586f6e2 upstream.

Please consider this small patch for the usb option-card driver.
This patch adds the ZTE 622 usb modem device.

Signed-off-by: Albert Pauw <albert.pauw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -282,6 +282,7 @@ static int  option_send_setup(struct tty
 
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
+#define ZTE_PRODUCT_MF622			0x0001
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
@@ -499,6 +500,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
+	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },


