Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYKLRKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYKLRKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYKLRKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:10:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:31317 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYKLRKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:10:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W29Lal8Hz9WkSNNsPD3pSLFtOSYZUIPF7DOYxB+ylbK7GUqr9JhVj/sp2fQ1N8CXtq
         NnLbZCKPUYPmPTNzQ9K5kQGD6Na7dAynoXp1ndruS7oLU1WJK6DK28nJUaOYEGATqNcw
         o1BtOvK7RyrevhXXOCI5RwP+dwS0ShbWT4bTA=
Message-ID: <8a966de80811120910r1a102576g4cf0f14fcff167e3@mail.gmail.com>
Date: Wed, 12 Nov 2008 15:10:07 -0200
From: "Leslie Watter" <leslie.watter@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Adding YISO u893 usb modem vendor and product IDs
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081112050230.GA19844@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8a966de80811111751x67feb700l774cbba30b21c81@mail.gmail.com>
	 <20081112050230.GA19844@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending with Signed-of-by as requested.

I would be glad if someone could take a look/apply the following patch.

This patch (against 2.6.27) adds YISO u893 usb modem vendor and
product ID to option.c.

I had a better experience using this modification and the same system.

The patch follows the same principle taken by ACME and applied by
gregkh in [1] and can be found as a file in [2].


Signed-off-by: Leslie Harlley Watter <leslie@watter.org>
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
--
1.5.6.3.350.g6c11a


[1] http://www.kernel.org/pub/linux/kernel/people/gregkh/usb/2.6/2.6.26-rc3/usb-option-fix-name-of-o+nda-msa501hs-hsdpa-modem.patch

[2] http://www.watter.net/linux/patches/linux-2.6.27-yiso-u893.patch

Thanks in advance,

LEslie
