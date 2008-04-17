Return-Path: <linux-kernel-owner+w=401wt.eu-S934284AbYDQKCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbYDQKCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934471AbYDQJhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:37:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42620 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934038AbYDQJg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:36:59 -0400
Date: Thu, 17 Apr 2008 12:36:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] drivers/pci/pci.c: add prototypes
Message-ID: <20080417093650.GB1677@cs181133002.pp.htv.fi>
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

 include/linux/pci.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

10ac874feed4260ac249df15ff52ab8b911fe4d4 diff --git a/include/linux/pci.h b/include/linux/pci.h
index ea760e5..964e7d9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1057,7 +1057,10 @@ extern int pci_pci_problems;
 extern unsigned long pci_cardbus_io_size;
 extern unsigned long pci_cardbus_mem_size;
 
-extern int pcibios_add_platform_entries(struct pci_dev *dev);
+int pcibios_add_platform_entries(struct pci_dev *dev);
+void pcibios_disable_device(struct pci_dev *dev);
+int pcibios_set_pcie_reset_state(struct pci_dev *dev,
+				 enum pcie_reset_state state);
 
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */

