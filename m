Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbXFPPrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbXFPPrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbXFPPrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:47:35 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:39427 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751792AbXFPPre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:47:34 -0400
Message-id: <28971219812257928376@wsc.cz>
In-reply-to: <116342983010020429@wsc.cz>
Subject: [PATCH 5/6] pci_ids, reorder some entries
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 16 Jun 2007 17:47:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci_ids, reorder some entries

Some lines are not vendor sorted, reorder it to comply with the rest of
document.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit ed29fc665adc4f8ef224318cb0877394f9b75ea4
tree cc7e3228e425c0dfaa9962f9606ee2360388bb95
parent 2438fcec127e3c3fede4f712154a25c2fd4af560
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:33:54 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:33:54 +0200

 include/linux/pci_ids.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6126078..279f2c0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -133,6 +133,9 @@
 
 /* Vendors and devices.  Sort key: vendor first, device next. */
 
+#define PCI_VENDOR_ID_TTTECH		0x0357
+#define PCI_DEVICE_ID_TTTECH_MC322	0x000a
+
 #define PCI_VENDOR_ID_DYNALINK		0x0675
 #define PCI_DEVICE_ID_DYNALINK_IS64PH	0x1702
 
@@ -1863,6 +1866,8 @@
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
 #define PCI_DEVICE_ID_OXSEMI_16PCI952PP	0x9523
 
+#define PCI_VENDOR_ID_CHELSIO		0x1425
+
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
 
 #define PCI_VENDOR_ID_MYRICOM		0x14c1
@@ -1971,8 +1976,6 @@
 #define PCI_DEVICE_ID_ENE_720		0x1421
 #define PCI_DEVICE_ID_ENE_722		0x1422
 
-#define PCI_VENDOR_ID_CHELSIO		0x1425
-
 #define PCI_SUBVENDOR_ID_PERLE          0x155f
 #define PCI_SUBDEVICE_ID_PCI_RAS4       0xf001
 #define PCI_SUBDEVICE_ID_PCI_RAS8       0xf010
@@ -1995,6 +1998,9 @@
 #define PCI_DEVICE_ID_MELLANOX_SINAI_OLD 0x5e8c
 #define PCI_DEVICE_ID_MELLANOX_SINAI	0x6274
 
+#define PCI_VENDOR_ID_QUICKNET		0x15e2
+#define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
+
 #define PCI_VENDOR_ID_PDC		0x15e9
 
 #define PCI_VENDOR_ID_FARSITE           0x1619
@@ -2366,13 +2372,7 @@
 #define PCI_DEVICE_ID_TIGERJET_300	0x0001
 #define PCI_DEVICE_ID_TIGERJET_100	0x0002
 
-#define PCI_VENDOR_ID_TTTECH		0x0357
-#define PCI_DEVICE_ID_TTTECH_MC322	0x000a
-
 #define PCI_VENDOR_ID_XILINX_RME	0xea60
 #define PCI_DEVICE_ID_RME_DIGI32	0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
-
-#define PCI_VENDOR_ID_QUICKNET		0x15e2
-#define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
