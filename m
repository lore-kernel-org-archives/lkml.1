Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbYCWIr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbYCWIr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbYCWILU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:20 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2325 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760028AbYCWILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:18 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 087/148] include/asm-x86/pci_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:02 -0700
Message-Id: <1206259443-13210-88-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pci_64.h |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/pci_64.h b/include/asm-x86/pci_64.h
index da8266a..f330234 100644
--- a/include/asm-x86/pci_64.h
+++ b/include/asm-x86/pci_64.h
@@ -1,12 +1,10 @@
 #ifndef __x8664_PCI_H
 #define __x8664_PCI_H
 
-
 #ifdef __KERNEL__
 
-
 #ifdef CONFIG_CALGARY_IOMMU
-static inline void* pci_iommu(struct pci_bus *bus)
+static inline void *pci_iommu(struct pci_bus *bus)
 {
 	struct pci_sysdata *sd = bus->sysdata;
 	return sd->iommu;
@@ -19,11 +17,10 @@ static inline void set_pci_iommu(struct pci_bus *bus, void *val)
 }
 #endif /* CONFIG_CALGARY_IOMMU */
 
-
-extern int (*pci_config_read)(int seg, int bus, int dev, int fn, int reg, int len, u32 *value);
-extern int (*pci_config_write)(int seg, int bus, int dev, int fn, int reg, int len, u32 value);
-
-
+extern int (*pci_config_read)(int seg, int bus, int dev, int fn,
+			      int reg, int len, u32 *value);
+extern int (*pci_config_write)(int seg, int bus, int dev, int fn,
+			       int reg, int len, u32 value);
 
 extern void dma32_reserve_bootmem(void);
 extern void pci_iommu_alloc(void);
@@ -66,5 +63,4 @@ extern void pci_iommu_alloc(void);
 
 #endif /* __KERNEL__ */
 
-
 #endif /* __x8664_PCI_H */
-- 
1.5.4.rc2

