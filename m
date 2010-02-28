Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031396Ab0B1Fv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 00:51:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64336 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0B1FvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 00:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=pzuvOhwYgXMam43mhmrj0+cCsnkbM73dizrtzCvRvvbWuCF7X5VTMDm4Kr6cOsd/Gb
         hqkaL+hlIhldnp8gc1g18mq+Wxe6hKcNPiiejzkVCCGZYPtVTc6cZK3mTO4O/MiP5SHj
         z/ulJ2yMolUa4SgYv85JhB1EexqEgWQ7jf8JQ=
Subject: [PATCH] USB, Option, Add support for a variant of DLink DWM 652 U5
From: Huang Ying <huang.ying.caritas@gmail.com>
Reply-To: huang.ying.caritas@gmail.com
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Feb 2010 13:51:29 +0800
Message-ID: <1267336289.9610.2.camel@caritas-mobile.ml.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a DLink DWM 652 U5 USB 3G modem has product ID 0xce1e instead
of orignal 0xce16. The new ID is added.

And I found there are two entries for 0xce16, one has raw number, the
other has symbol DLINK_PRODUCT_DWM_652_U5. This is fixed too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/usb/serial/option.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/usb/serial/option.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/option.c
+++ linux-2.6/drivers/usb/serial/option.c
@@ -309,6 +309,7 @@
 #define DLINK_VENDOR_ID				0x1186
 #define DLINK_PRODUCT_DWM_652			0x3e04
 #define DLINK_PRODUCT_DWM_652_U5		0xce16
+#define DLINK_PRODUCT_DWM_652_U5A		0xce1e
 
 #define QISDA_VENDOR_ID				0x1da5
 #define QISDA_PRODUCT_H21_4512			0x4512
@@ -632,6 +633,7 @@
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5) }, /* Yes, ALINK_VENDOR_ID */
+	{ USB_DEVICE(ALINK_VENDOR_ID, DLINK_PRODUCT_DWM_652_U5A) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4523) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4515) },
@@ -639,7 +641,6 @@
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_G450) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
-	{ USB_DEVICE(ALINK_VENDOR_ID, 0xce16) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },


