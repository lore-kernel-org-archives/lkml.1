Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbYBUUao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbYBUUao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbYBUUaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:30:19 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36709 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbYBUUaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:30:11 -0500
Message-ID: <47BDDF70.8090609@davidnewall.com>
Date: Fri, 22 Feb 2008 07:00:40 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.24.1
References: <479A83DE.8020002@davidnewall.com> <20080202074406.GA31516@1wt.eu> <47A46BF8.6030306@davidnewall.com> <47BDDD4E.1080000@davidnewall.com>
In-Reply-To: <47BDDD4E.1080000@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I forgot to include the changes to pl2303.h.  Here's a second patch:

--- pl2303.h.orig	2008-01-01 22:36:40.000000000 +1030
+++ pl2303.h	2008-02-22 06:11:19.000000000 +1030
@@ -9,7 +9,10 @@
  */
 #define PL2303_VENDOR_ID	0x067b
 #define PL2303_PRODUCT_ID	0x2303
-#define PL2303_PRODUCT_ID_RSAQ2	0x04bb
+#define PL2303_PRODUCT_ID_RSAQ2		0x04bb
+#define PL2303_PRODUCT_ID_DCU11		0x1234
+#define PL2303_PRODUCT_ID_PHAROS	0xaaa0
+#define PL2303_PRODUCT_ID_RSAQ3		0xaaa2
 
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
@@ -17,18 +20,22 @@
 
 #define IODATA_VENDOR_ID	0x04bb
 #define IODATA_PRODUCT_ID	0x0a03
+#define IODATA_PRODUCT_ID_RSAQ5	0x0a0e
 
 #define ELCOM_VENDOR_ID		0x056e
 #define ELCOM_PRODUCT_ID	0x5003
+#define ELCOM_PRODUCT_ID_UCSGT	0x5004
 
 #define ITEGNO_VENDOR_ID	0x0eba
 #define ITEGNO_PRODUCT_ID	0x1080
+#define ITEGNO_PRODUCT_ID_2080	0x2080
 
 #define MA620_VENDOR_ID		0x0df7
 #define MA620_PRODUCT_ID	0x0620
 
 #define RATOC_VENDOR_ID		0x0584
 #define RATOC_PRODUCT_ID	0xb000
+#define RATOC_PRODUCT_ID_USB60F	0xb020
 
 #define TRIPP_VENDOR_ID		0x2478
 #define TRIPP_PRODUCT_ID	0x2008
@@ -41,3 +48,67 @@
 
 #define SITECOM_VENDOR_ID	0x6189
 #define SITECOM_PRODUCT_ID	0x2068
+
+/* Alcatel OT535/735 USB cable */
+#define ALCATEL_VENDOR_ID	0x11f7
+#define ALCATEL_PRODUCT_ID	0x02df
+
+/* Samsung I330 phone cradle */
+#define SAMSUNG_VENDOR_ID	0x04e8
+#define SAMSUNG_PRODUCT_ID	0x8001
+
+#define SIEMENS_VENDOR_ID	0x11f5
+#define SIEMENS_PRODUCT_ID_SX1	0x0001
+#define SIEMENS_PRODUCT_ID_X65	0x0003
+#define SIEMENS_PRODUCT_ID_X75	0x0004
+#define SIEMENS_PRODUCT_ID_EF81	0x0005
+
+#define SYNTECH_VENDOR_ID	0x0745
+#define SYNTECH_PRODUCT_ID	0x0001
+
+/* Nokia CA-42 Cable */
+#define NOKIA_CA42_VENDOR_ID	0x078b
+#define NOKIA_CA42_PRODUCT_ID	0x1234
+
+/* CA-42 CLONE Cable www.ca-42.com chipset: Prolific Technology Inc */
+#define CA_42_CA42_VENDOR_ID	0x10b5
+#define CA_42_CA42_PRODUCT_ID	0xac70
+
+#define SAGEM_VENDOR_ID		0x079b
+#define SAGEM_PRODUCT_ID	0x0027
+
+/* Leadtek GPS 9531 (ID 0413:2101) */
+#define LEADTEK_VENDOR_ID	0x0413
+#define LEADTEK_9531_PRODUCT_ID	0x2101
+
+/* USB GSM cable from Speed Dragon Multimedia, Ltd */
+#define SPEEDDRAGON_VENDOR_ID	0x0e55
+#define SPEEDDRAGON_PRODUCT_ID	0x110b
+
+/* DATAPILOT Universal-2 Phone Cable */
+#define DATAPILOT_U2_VENDOR_ID	0x0731
+#define DATAPILOT_U2_PRODUCT_ID	0x2003
+
+/* Belkin "F5U257" Serial Adapter */
+#define BELKIN_VENDOR_ID	0x050d
+#define BELKIN_PRODUCT_ID	0x0257
+
+/* Alcor Micro Corp. USB 2.0 TO RS-232 */
+#define ALCOR_VENDOR_ID		0x058F
+#define ALCOR_PRODUCT_ID	0x9720
+
+/* Willcom WS002IN Data Driver (by NetIndex Inc.) */
+#define WS002IN_VENDOR_ID	0x11f6
+#define WS002IN_PRODUCT_ID	0x2001
+
+/* Corega CG-USBRS232R Serial Adapter */
+#define COREGA_VENDOR_ID	0x07aa
+#define COREGA_PRODUCT_ID	0x002a
+
+/* HL HL-340 (ID: 4348:5523) */
+#define HL340_VENDOR_ID		0x4348
+#define HL340_PRODUCT_ID	0x5523
+
+/* Y.C. Cable U.S.A., Inc - USB to RS-232 */
+#define YCCABLE_VENDOR_ID	0x05ad
+#define YCCABLE_PRODUCT_ID	0x0fba


