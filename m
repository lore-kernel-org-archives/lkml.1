Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbYEESaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbYEESaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760652AbYEES04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:26:56 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54987 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760645AbYEES0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:26:55 -0400
Date: Mon, 5 May 2008 21:25:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [2.6 patch] drivers/pci/pci.c: add prototypes
Message-ID: <20080505182547.GT17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds prototypes for pcibios_disable_device() and
pcibios_set_pcie_reset_state() in include/linux/pci.h

While I was at it, I also removed the unneeded "extern" from the
prototype of pcibios_add_platform_entries().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 17 Apr 2008

a4c9a22364a94d0be8ccac477860c71b09e8db02 diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96acd0d..aab4123 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1058,7 +1058,10 @@ extern int pci_pci_problems;
 extern unsigned long pci_cardbus_io_size;
 extern unsigned long pci_cardbus_mem_size;
 
-extern int pcibios_add_platform_entries(struct pci_dev *dev);
+int pcibios_add_platform_entries(struct pci_dev *dev);
+void pcibios_disable_device(struct pci_dev *dev);
+int pcibios_set_pcie_reset_state(struct pci_dev *dev,
+				 enum pcie_reset_state state);
 
 #ifdef CONFIG_PCI_MMCONFIG
 extern void __init pci_mmcfg_early_init(void);
