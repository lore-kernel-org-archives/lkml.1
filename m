Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbYKLBvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbYKLBvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYKLBvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:51:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:22448 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYKLBvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:51:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KN5jRaJ9CoaA61sXkHFEOfvvbxX/997B4hRLy9eLWy6nB+N1W89JwBfv5oTJm8udCm
         JRqp5jkIfjJqF4F7VXB4HxTJ1WJO6LpBZF+QiFSbtxV0iSJadsGkLKFyErhEgTxH1Kiz
         WD+ljJESmgFe9oJyNfv0ag3tEkaQVZ5BtO884=
Message-ID: <8a966de80811111751x67feb700l774cbba30b21c81@mail.gmail.com>
Date: Tue, 11 Nov 2008 23:51:10 -0200
From: "Leslie Watter" <leslie.watter@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Adding YISO u893 usb modem vendor and product IDs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would be glad if someone could take a look/apply the following patch.

This patch (against 2.6.27) adds YISO u893 usb modem vendor and
product ID to option.c.

I had a better experience using this modification and the same system.

The patch follows the same principle taken by ACME and applied by
gregkh in [1] and can be found as a file in [2].

----------------
 option.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 73f8277..8d1bd76 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -124,6 +124,11 @@ static int  option_send_setup(struct tty_struct
*tty, struct usb_serial_port *po

 #define NOVATELWIRELESS_VENDOR_ID              0x1410

+/* YISO PRODUCTS */
+
+#define YISO_VENDOR_ID                         0x0EAB
+#define YISO_PRODUCT_U893                      0xC893
+
 /* MERLIN EVDO PRODUCTS */
 #define NOVATELWIRELESS_PRODUCT_V640           0x1100
 #define NOVATELWIRELESS_PRODUCT_V620           0x1110
@@ -324,6 +329,7 @@ static struct usb_device_id option_ids[] = {
        { USB_DEVICE(AXESSTEL_VENDOR_ID, AXESSTEL_PRODUCT_MV110H) },
        { USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_MSA501HS) },
        { USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
+       { USB_DEVICE(YISO_VENDOR_ID, YISO_PRODUCT_U893) },
        { USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
        { USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
        { USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1004) },




[1] http://www.kernel.org/pub/linux/kernel/people/gregkh/usb/2.6/2.6.26-rc3/usb-option-fix-name-of-o+nda-msa501hs-hsdpa-modem.patch

[2] http://www.watter.net/linux/patches/linux-2.6.27-yiso-u893.patch

Thanks in advance,

LEslie
