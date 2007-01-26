Return-Path: <linux-kernel-owner+w=401wt.eu-S965669AbXAZNu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965669AbXAZNu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965670AbXAZNu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:50:26 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:47051 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965669AbXAZNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:50:25 -0500
Date: Fri, 26 Jan 2007 22:51:38 +0900 (JST)
Message-Id: <20070126.225138.73674749.yoshfuji@linux-ipv6.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org,
       kozakai@linux-ipv6.org
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
Subject: [USBSERIAL] PL2303: Willcom WS002IN Support.
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 5dc2ac9..8d72a2e 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -83,6 +83,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(BELKIN_VENDOR_ID, BELKIN_PRODUCT_ID) },
 	{ USB_DEVICE(ALCOR_VENDOR_ID, ALCOR_PRODUCT_ID) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ID) },
+	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 65a5039..f9a71d0 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -97,3 +97,8 @@
 /* Huawei E620 UMTS/HSDPA card (ID: 12d1:1001) */
 #define HUAWEI_VENDOR_ID	0x12d1
 #define HUAWEI_PRODUCT_ID	0x1001
+
+/* Willcom WS002IN Data Driver (by NetIndex Inc.) */
+#define WS002IN_VENDOR_ID	0x11f6
+#define WS002IN_PRODUCT_ID	0x2001
+
-- 
1.4.4.1.g562ce

