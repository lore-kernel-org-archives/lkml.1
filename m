Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYLKT1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYLKT1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbYLKTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:32 -0500
Received: from kroah.org ([198.145.64.141]:56053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757528AbYLKTSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:24 -0500
Date: Thu, 11 Dec 2008 11:14:31 -0800
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
       alan@lxorguk.ukuu.org.uk, Denis Joseph Barrow <D.Barow@option.com>
Subject: [patch 27/83] USB: option.c remove duplicate device ids now
	supported in hso.c
Message-ID: <20081211191431.GA5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-option.c-remove-duplicate-device-ids-now-supported-in-hso.c.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Denis Joseph Barrow <D.Barow@option.com>

commit 631556a0763ac155c82bbcbeed7e4b28bd737927 upstream.

Remove duplicate device ids which are now supported by drivers/usb/net/hso.c

Signed-off-by: Denis Joseph Barrow <D.Barow@option.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/option.c |   22 ----------------------
 1 file changed, 22 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -79,27 +79,16 @@ static int  option_send_setup(struct tty
 #define OPTION_PRODUCT_VIPER			0x6600
 #define OPTION_PRODUCT_VIPER_BUS		0x6601
 #define OPTION_PRODUCT_GT_MAX_READY		0x6701
-#define OPTION_PRODUCT_GT_MAX			0x6711
 #define OPTION_PRODUCT_FUJI_MODEM_LIGHT		0x6721
 #define OPTION_PRODUCT_FUJI_MODEM_GT		0x6741
 #define OPTION_PRODUCT_FUJI_MODEM_EX		0x6761
-#define OPTION_PRODUCT_FUJI_NETWORK_LIGHT	0x6731
-#define OPTION_PRODUCT_FUJI_NETWORK_GT		0x6751
-#define OPTION_PRODUCT_FUJI_NETWORK_EX		0x6771
 #define OPTION_PRODUCT_KOI_MODEM		0x6800
-#define OPTION_PRODUCT_KOI_NETWORK		0x6811
 #define OPTION_PRODUCT_SCORPION_MODEM		0x6901
-#define OPTION_PRODUCT_SCORPION_NETWORK		0x6911
 #define OPTION_PRODUCT_ETNA_MODEM		0x7001
-#define OPTION_PRODUCT_ETNA_NETWORK		0x7011
 #define OPTION_PRODUCT_ETNA_MODEM_LITE		0x7021
 #define OPTION_PRODUCT_ETNA_MODEM_GT		0x7041
 #define OPTION_PRODUCT_ETNA_MODEM_EX		0x7061
-#define OPTION_PRODUCT_ETNA_NETWORK_LITE	0x7031
-#define OPTION_PRODUCT_ETNA_NETWORK_GT		0x7051
-#define OPTION_PRODUCT_ETNA_NETWORK_EX		0x7071
 #define OPTION_PRODUCT_ETNA_KOI_MODEM		0x7100
-#define OPTION_PRODUCT_ETNA_KOI_NETWORK		0x7111
 
 #define HUAWEI_VENDOR_ID			0x12D1
 #define HUAWEI_PRODUCT_E600			0x1001
@@ -239,27 +228,16 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_VIPER) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_VIPER_BUS) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GT_MAX_READY) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GT_MAX) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_FUJI_MODEM_LIGHT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_FUJI_MODEM_GT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_FUJI_MODEM_EX) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_FUJI_NETWORK_LIGHT) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_FUJI_NETWORK_GT) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_FUJI_NETWORK_EX) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_KOI_MODEM) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_KOI_NETWORK) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_SCORPION_MODEM) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_SCORPION_NETWORK) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_NETWORK) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM_LITE) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM_GT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM_EX) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_NETWORK_LITE) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_NETWORK_GT) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_NETWORK_EX) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
-	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },

