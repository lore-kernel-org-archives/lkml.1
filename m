Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbXFRIzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbXFRIzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbXFRIz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:55:29 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:37047 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755419AbXFRIz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:55:28 -0400
Message-id: <26878163791558122327@wsc.cz>
In-reply-to: <29285162611339719891@wsc.cz>
Subject: [PATCH 3/5] pci_ids, reorder some entries
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Date: Mon, 18 Jun 2007 10:55:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci_ids, reorder some entries

Some lines are not vendor sorted, reorder it to comply with the rest of
document.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 6e779d054a804b16394dacb669facc3b1da8aae8
tree 8026f30611eae7bfcb30d3f32416dda2eb2bbbcc
parent 2c144a8d6501ff8b137077b776df00423ca9ac19
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:33:54 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 18 Jun 2007 10:46:41 +0200

 include/linux/pci_ids.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index a8d5830..19a5977 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -133,6 +133,9 @@
 
 /* Vendors and devices.  Sort key: vendor first, device next. */
 
+#define PCI_VENDOR_ID_TTTECH		0x0357
+#define PCI_DEVICE_ID_TTTECH_MC322	0x000a
+
 #define PCI_VENDOR_ID_DYNALINK		0x0675
 #define PCI_DEVICE_ID_DYNALINK_IS64PH	0x1702
 
@@ -1903,6 +1906,8 @@
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
 #define PCI_DEVICE_ID_OXSEMI_16PCI952PP	0x9523
 
+#define PCI_VENDOR_ID_CHELSIO		0x1425
+
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
 
 #define PCI_VENDOR_ID_MYRICOM		0x14c1
@@ -2011,8 +2016,6 @@
 #define PCI_DEVICE_ID_ENE_720		0x1421
 #define PCI_DEVICE_ID_ENE_722		0x1422
 
-#define PCI_VENDOR_ID_CHELSIO		0x1425
-
 #define PCI_SUBVENDOR_ID_PERLE          0x155f
 #define PCI_SUBDEVICE_ID_PCI_RAS4       0xf001
 #define PCI_SUBDEVICE_ID_PCI_RAS8       0xf010
@@ -2036,6 +2039,9 @@
 #define PCI_DEVICE_ID_MELLANOX_SINAI_OLD 0x5e8c
 #define PCI_DEVICE_ID_MELLANOX_SINAI	0x6274
 
+#define PCI_VENDOR_ID_QUICKNET		0x15e2
+#define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
+
 #define PCI_VENDOR_ID_PDC		0x15e9
 
 
@@ -2414,13 +2420,7 @@
 #define PCI_DEVICE_ID_TIGERJET_300	0x0001
 #define PCI_DEVICE_ID_TIGERJET_100	0x0002
 
-#define PCI_VENDOR_ID_TTTECH		0x0357
-#define PCI_DEVICE_ID_TTTECH_MC322	0x000A
-
 #define PCI_VENDOR_ID_XILINX_RME	0xea60
 #define PCI_DEVICE_ID_RME_DIGI32	0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
-
-#define PCI_VENDOR_ID_QUICKNET		0x15E2
-#define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
