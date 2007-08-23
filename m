Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbXHWWnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbXHWWnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934174AbXHWWj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:39:57 -0400
Received: from smtp28.orange.fr ([80.12.242.100]:16967 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603AbXHWWjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:39:55 -0400
X-ME-UUID: 20070823223736107.1A459700008C@mwinf2817.orange.fr
Message-ID: <46CE0A59.8050805@bachelot.org>
Date: Fri, 24 Aug 2007 00:29:45 +0200
From: Xavier Bachelot <xavier@bachelot.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: airlied@linux.ie, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Add device id for P4M900 to via-agp module
Content-Type: multipart/mixed;
 boundary="------------070204040704020802020406"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070204040704020802020406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a new VIA chipset that works with the existing code. It only 
needs the device id to be added for detection.


--------------070204040704020802020406
Content-Type: text/x-patch;
 name="P4M900-agpgart.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="P4M900-agpgart.patch"

--- a/drivers/char/agp/via-agp.c	2007-08-23 23:41:56.000000000 +0200
+++ b/drivers/char/agp/via-agp.c	2007-08-23 23:45:13.000000000 +0200
@@ -399,6 +399,11 @@
 		.device_id  = PCI_DEVICE_ID_VIA_P4M890,
 		.chipset_name   = "P4M890",
 	},
+	/* P4M900 */
+	{
+		.device_id  = PCI_DEVICE_ID_VIA_VT3364,
+		.chipset_name   = "P4M900",
+	},
 	{ }, /* dummy final entry, always present */
 };
 
--- a/include/linux/pci_ids.h	2007-08-23 23:42:04.000000000 +0200
+++ b/include/linux/pci_ids.h	2007-08-23 23:48:19.000000000 +0200
@@ -1296,6 +1296,7 @@
 #define PCI_DEVICE_ID_VIA_VT3324	0x0324
 #define PCI_DEVICE_ID_VIA_VT3336	0x0336
 #define PCI_DEVICE_ID_VIA_VT3351	0x0351
+#define PCI_DEVICE_ID_VIA_VT3364	0x0364
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
 #define PCI_DEVICE_ID_VIA_82C561	0x0561

--------------070204040704020802020406--

