Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbXHVAET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbXHVAET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbXHVAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:04:11 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:38179 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbXHVAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:04:10 -0400
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 20:04:10 EDT
Date: Tue, 21 Aug 2007 17:49:07 -0600
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] Add missing PCI capability IDs
Message-ID: <20070821234907.GP27128@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These IDs are in pciutils, but haven't been added to the kernel
yet.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---

diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 495d368..1ef8712 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -202,8 +202,12 @@
 #define  PCI_CAP_ID_CHSWP	0x06	/* CompactPCI HotSwap */
 #define  PCI_CAP_ID_PCIX	0x07	/* PCI-X */
 #define  PCI_CAP_ID_HT		0x08	/* HyperTransport */
-#define  PCI_CAP_ID_VNDR	0x09	/* Vendor specific capability */
+#define  PCI_CAP_ID_VNDR	0x09	/* Vendor specific */
+#define  PCI_CAP_ID_DBG		0x0A	/* Debug port */
+#define  PCI_CAP_ID_CCRC	0x0B	/* CompactPCI Central Resource Control */
 #define  PCI_CAP_ID_SHPC 	0x0C	/* PCI Standard Hot-Plug Controller */
+#define  PCI_CAP_ID_SSVID	0x0D	/* Bridge subsystem vendor/device ID */
+#define  PCI_CAP_ID_AGP3	0x0E	/* AGP Target PCI-PCI bridge */
 #define  PCI_CAP_ID_EXP 	0x10	/* PCI Express */
 #define  PCI_CAP_ID_MSIX	0x11	/* MSI-X */
 #define PCI_CAP_LIST_NEXT	1	/* Next capability in the list */
