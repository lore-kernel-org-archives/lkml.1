Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0BHSXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:23:34 -0500
Received: from wp065.webpack.hosteurope.de ([80.237.132.72]:39902 "EHLO
	wp065.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527Ab0BHSXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:23:33 -0500
X-Greylist: delayed 1150 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 13:23:33 EST
Message-ID: <4B705244.2010606@ccube.de>
Date: Mon, 08 Feb 2010 19:04:52 +0100
From: ccube <friends@ccube.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100205 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] option.c added DELL wireless HSDPA 5540 Modem
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;friends@ccube.de;1265653413;6c2ad677;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,
i really dont know if everything is correct.
This is my first submit into this mailing list.
I added support for my HSDPA UMTS-card.
Perhaps you can check! ;)

regards,
Lukas


- ---

- --- drivers/usb/serial/option.c.old	2010-02-08 18:53:12.583195124 +0100
+++ drivers/usb/serial/option.c	2010-02-08 18:55:39.039023408 +0100
@@ -246,6 +246,8 @@
 #define DELL_PRODUCT_5520_MINICARD_GENERIC_L	0x8137
 #define DELL_PRODUCT_5520_MINICARD_GENERIC_I	0x8138

+#define DELL_PRODUCT_5540_MINICARD		0x8184
+
 #define DELL_PRODUCT_5730_MINICARD_SPRINT	0x8180
 #define DELL_PRODUCT_5730_MINICARD_TELUS	0x8181
 #define DELL_PRODUCT_5730_MINICARD_VZW		0x8182
@@ -494,6 +496,7 @@
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_SPRINT) },	/*
Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_TELUS) },	/*
Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/*
Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5540_MINICARD) }, 		/* Dell
Wireless 5540 Mobile Broadband HSPA Mini-Card */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/*
ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLcFJEAAoJEM98oVUsldl38A8H/1Wb1z8esHxL47IJ9Yidc4Su
UgJyE2BLBZSbMclqHKv4csYii0Y4Fa0hFWifK79GwqwDdmFtiywT/ig9QGcYLEiO
+TemWMr1bvqvAicdadj1zdzpEZUsXvdSxoYnu3c5CLzKmk40/JlNQ50zxAb6RM71
KK4CDPen160nVVnP8sQl3LxyXfNAK5nEB+ocrVRQiz8kKb+9oZs78yOC3nkqjC4K
uZNnD/4ruFlYhNOqvnbfnSwefTpZtgo0OM8tSeTt4w8/7GRNkaXpa3ru/7GszSSu
qx+ULIQZvcQhqRZPamMmbo9yhWflmcmE4mA6ffcP7cCTtLEucHvdALkLYT8PX6o=
=zgdC
-----END PGP SIGNATURE-----
