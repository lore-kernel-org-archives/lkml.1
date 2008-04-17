Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYDQXj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYDQXj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 19:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYDQXjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 19:39:47 -0400
Received: from mail1.physik.fu-berlin.de ([160.45.35.12]:33553 "EHLO
	mail1.physik.fu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbYDQXjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 19:39:46 -0400
X-Greylist: delayed 2977 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 19:39:46 EDT
Subject: [PATCH] usb-serial: option: Don't match Huawei driver CD images
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: smurf@smurf.noris.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Fri, 18 Apr 2008 00:49:29 +0200
Message-Id: <1208472569.14194.5.camel@hermes2.karcher.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-HELO-Warning: Remote host 89.247.224.62 (i59f7e03e.versanet.de) incorrectly presented itself as [192.168.0.121]
X-ZEDV-Virus-Scanned: No viruses found. [ClamAV 0.92/6813/Thu Apr 17 19:00:03 2008]
X-ZEDV-Spam-Level: ----
X-ZEDV-Spam-Checker-Version: SpamAssassin 3.2.3 (2007-08-08) on zs01.physik.fu-berlin.de
X-ZEDV-Spam-Status: No, score=-4.4 required=5.0 tests=ALL_TRUSTED,BAYES_00,UPPERCASE_50_75 autolearn=no version=3.2.3
X-ZEDV-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.0 UPPERCASE_50_75 message body is 50-75% uppercase
X-Scan-Signature: f32ea470439abc81cc7c1dd7a9431344
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

Add the interface info matching to all Huawei cards, as they all also
contain a Mass Storage Device interface (usually containing Windows
drivers) which should not get bound by this driver.

See also drivers/usb/storage/unusual_devs.h

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

---

Formatting as one-liners is done like in HUAWEI_PRODUCT_E220 entries
that were already present. This breaks the 80 chars/line recommendation,
feel free to reformat (or tell me to submit a reformatted patch).

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d101025..45a2eff 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -231,25 +231,25 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_NETWORK_EX) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_NETWORK) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220BIS, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1401) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1403) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1405) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1406) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1408) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1409) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1410) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1411) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1412) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1413) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1414) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1415) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1416) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1417) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1418) },
-	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1419) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1401, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1403, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1405, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1406, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1408, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1409, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1410, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1411, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1412, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1413, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1414, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1415, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1416, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1417, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1418, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1419, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */


