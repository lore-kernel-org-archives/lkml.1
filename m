Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZCYTMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZCYTMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZCYTMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:12:01 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:34077 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZCYTL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:11:59 -0400
Message-ID: <49CA81FA.10901@grupopie.com>
Date: Wed, 25 Mar 2009 19:11:54 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthias Urlichs <smurf@smurf.noris.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] option.c: Remove unnecessary/duplicated VID/PID
Content-Type: multipart/mixed;
 boundary="------------040208020905000701040309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040208020905000701040309
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

Changes are as follows:
- Version bump
- ZTE_VENDOR_ID is the same as ONDA_VENDOR_ID. According to
http://www.linux-usb.org/usb.ids, ONDA Communication S.p.A. holds that
VENDOR_ID
- ONDA_PRODUCT_MSA501HS PRODUCT_ID is now the same as ZTE_PRODUCT_MF622.
Keeping ZTE_PRODUCT_MF622 as it was added by commit
9ea19b82f3126da4e47d6b94563a3c2cd586f6e2 and and there was no opposition
- AMOI_VENDOR_ID defined twice
- AMOI_PRODUCT_H01 and AMOI_PRODUCT_9508 are duplicated. Keeping
AMOI_PRODUCT_H01
- Other minor code cleansing...

This patch is against Kernel v2.6.29

-- 
Regards,
Rui Santos


--------------040208020905000701040309
Content-Type: text/x-patch;
 name="option-clean.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="option-clean.patch"

diff -uprN a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c	2009-03-23 23:12:14.000000000 +0000
+++ b/drivers/usb/serial/option.c	2009-03-25 18:57:09.000000000 +0000
@@ -28,7 +28,7 @@
   device features.
 */
 
-#define DRIVER_VERSION "v0.7.2"
+#define DRIVER_VERSION "v0.7.3"
 #define DRIVER_AUTHOR "Matthias Urlichs <smurf@smurf.noris.de>"
 #define DRIVER_DESC "USB Driver for GSM modems"
 
@@ -166,13 +166,12 @@ static int  option_send_setup(struct tty
 #define QUANTA_PRODUCT_GKE			0xEA05
 #define QUANTA_PRODUCT_GLE			0xEA06
 
-#define NOVATELWIRELESS_VENDOR_ID		0x1410
-
 /* YISO PRODUCTS */
-
 #define YISO_VENDOR_ID				0x0EAB
 #define YISO_PRODUCT_U893			0xC893
 
+#define NOVATELWIRELESS_VENDOR_ID		0x1410
+
 /* MERLIN EVDO PRODUCTS */
 #define NOVATELWIRELESS_PRODUCT_V640		0x1100
 #define NOVATELWIRELESS_PRODUCT_V620		0x1110
@@ -225,17 +224,14 @@ static int  option_send_setup(struct tty
 #define DELL_PRODUCT_5505_MINICARD		0x8116
 #define DELL_PRODUCT_5700_EXPRESSCARD		0x8117
 #define DELL_PRODUCT_5510_EXPRESSCARD		0x8118
-
 #define DELL_PRODUCT_5700_MINICARD_SPRINT	0x8128
 #define DELL_PRODUCT_5700_MINICARD_TELUS	0x8129
-
 #define DELL_PRODUCT_5720_MINICARD_VZW		0x8133
 #define DELL_PRODUCT_5720_MINICARD_SPRINT	0x8134
 #define DELL_PRODUCT_5720_MINICARD_TELUS	0x8135
 #define DELL_PRODUCT_5520_MINICARD_CINGULAR	0x8136
 #define DELL_PRODUCT_5520_MINICARD_GENERIC_L	0x8137
 #define DELL_PRODUCT_5520_MINICARD_GENERIC_I	0x8138
-
 #define DELL_PRODUCT_5730_MINICARD_SPRINT	0x8180
 #define DELL_PRODUCT_5730_MINICARD_TELUS	0x8181
 #define DELL_PRODUCT_5730_MINICARD_VZW		0x8182
@@ -253,7 +249,6 @@ static int  option_send_setup(struct tty
 #define AXESSTEL_PRODUCT_MV110H			0x1000
 
 #define ONDA_VENDOR_ID				0x19d2
-#define ONDA_PRODUCT_MSA501HS			0x0001
 #define ONDA_PRODUCT_ET502HS			0x0002
 #define ONDA_PRODUCT_MT503HS			0x2000
 
@@ -267,20 +262,15 @@ static int  option_send_setup(struct tty
 #define BANDRICH_PRODUCT_1008			0x1008
 #define BANDRICH_PRODUCT_1009			0x1009
 #define BANDRICH_PRODUCT_100A			0x100a
-
 #define BANDRICH_PRODUCT_100B			0x100b
 #define BANDRICH_PRODUCT_100C			0x100c
 #define BANDRICH_PRODUCT_100D			0x100d
 #define BANDRICH_PRODUCT_100E			0x100e
-
 #define BANDRICH_PRODUCT_100F			0x100f
 #define BANDRICH_PRODUCT_1010			0x1010
 #define BANDRICH_PRODUCT_1011			0x1011
 #define BANDRICH_PRODUCT_1012			0x1012
 
-#define AMOI_VENDOR_ID			0x1614
-#define AMOI_PRODUCT_9508			0x0800
-
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define MAXON_VENDOR_ID				0x16d8
@@ -289,7 +279,6 @@ static int  option_send_setup(struct tty
 #define TELIT_PRODUCT_UC864E			0x1003
 
 /* ZTE PRODUCTS */
-#define ZTE_VENDOR_ID				0x19d2
 #define ZTE_PRODUCT_MF622			0x0001
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
@@ -395,7 +384,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V740) }, /* Novatel Merlin EX720/V740/X720 */
@@ -449,7 +437,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
 	{ USB_DEVICE(AXESSTEL_VENDOR_ID, AXESSTEL_PRODUCT_MV110H) },
-	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_MSA501HS) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0003) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0004) },
@@ -485,6 +472,10 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0028) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, 0x0029) },
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_MT503HS) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, ZTE_PRODUCT_MF622) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, ZTE_PRODUCT_MF626) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, ZTE_PRODUCT_MF628) },
+	{ USB_DEVICE(ONDA_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
 	{ USB_DEVICE(YISO_VENDOR_ID, YISO_PRODUCT_U893) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
 	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
@@ -509,10 +500,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
-	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622) },
-	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626) },
-	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
-	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(0x1da5, 0x4515) }, /* BenQ H20 */
 	{ } /* Terminating entry */

--------------040208020905000701040309--
