Return-Path: <linux-kernel-owner+w=401wt.eu-S934703AbYCWJG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703AbYCWJG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760334AbYCWIM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:28 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2374 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbYCWIMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:02 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 089/148] include/asm-x86/pci.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:04 -0700
Message-Id: <1206259443-13210-90-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pci.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
index 0659543..30bbde0 100644
--- a/include/asm-x86/pci.h
+++ b/include/asm-x86/pci.h
@@ -8,14 +8,13 @@
 #include <asm/scatterlist.h>
 #include <asm/io.h>
 
-
 #ifdef __KERNEL__
 
 struct pci_sysdata {
 	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 #ifdef CONFIG_X86_64
-	void*		iommu;		/* IOMMU private data */
+	void		*iommu;		/* IOMMU private data */
 #endif
 };
 
@@ -54,7 +53,7 @@ extern unsigned long pci_mem_start;
 #define PCIBIOS_MIN_CARDBUS_IO	0x4000
 
 void pcibios_config_init(void);
-struct pci_bus * pcibios_scan_root(int bus);
+struct pci_bus *pcibios_scan_root(int bus);
 
 void pcibios_set_master(struct pci_dev *dev);
 void pcibios_penalize_isa_irq(int irq, int active);
@@ -64,7 +63,8 @@ int pcibios_set_irq_routing(struct pci_dev *dev, int pin, int irq);
 
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
-			       enum pci_mmap_state mmap_state, int write_combine);
+			       enum pci_mmap_state mmap_state,
+			       int write_combine);
 
 
 #ifdef CONFIG_PCI
-- 
1.5.4.rc2

