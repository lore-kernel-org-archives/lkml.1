Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYAHXbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYAHXbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYAHXa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:30:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:2248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbYAHXa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Y6moCsDKxr42gTBsay9QdtB/PNyMNCEQgPfEgCUoHt7XmIWxSc3C2VyE+RqzOndMVuxg1vHSfj8Jj0oQzqJw2bS1Wpt0mZKgVZkZSMUMfFzAZevkI/GTq1I9KZFr/FNi7jL3efnm815qv0vAaA58W/jEi4DjsBwuy33lWqEEdXY=
Date: Wed, 9 Jan 2008 00:31:07 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] x86: coding style fixes in arch/x86/pci/fixup.c
Message-ID: <20080109003107.459108ba@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple coding style fixes.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/pci/fixup.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 6cff66d..cb63007 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -19,7 +19,7 @@ static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 
 	printk(KERN_WARNING "PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
 	reg = 0xd0;
-	for(pxb=0; pxb<2; pxb++) {
+	for(pxb = 0; pxb < 2; pxb++) {
 		pci_read_config_byte(d, reg++, &busno);
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
@@ -56,7 +56,7 @@ static void __devinit  pci_fixup_umc_ide(struct pci_dev *d)
 	int i;
 
 	printk(KERN_WARNING "PCI: Fixing base address flags for device %s\n", pci_name(d));
-	for(i=0; i<4; i++)
+	for(i = 0; i < 4; i++)
 		d->resource[i].flags |= PCI_BASE_ADDRESS_SPACE_IO;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_UMC, PCI_DEVICE_ID_UMC_UM8886BF, pci_fixup_umc_ide);
@@ -127,7 +127,7 @@ static void pci_fixup_via_northbridge_bug(struct pci_dev *d)
 		   NB latency to zero */
 		pci_write_config_byte(d, PCI_LATENCY_TIMER, 0);
 
-		where = 0x95; /* the memory write queue timer register is 
+		where = 0x95; /* the memory write queue timer register is
 				different for the KT266x's: 0x95 not 0x55 */
 	} else if (d->device == PCI_DEVICE_ID_VIA_8363_0 &&
 			(d->revision == VIA_8363_KL133_REVISION_ID ||
@@ -230,7 +230,7 @@ static int quirk_pcie_aspm_write(struct pci_bus *bus, unsigned int devfn, int wh
 
 	if ((offset) && (where == offset))
 		value = value & 0xfffffffc;
-	
+
 	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
 }
 
@@ -271,8 +271,8 @@ static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 		 * after hot-remove, the pbus->devices is empty and this code
 		 * will set the offsets to zero and the bus ops to parent's bus
 		 * ops, which is unmodified.
-	 	 */
-		for (i= GET_INDEX(pdev->device, 0); i <= GET_INDEX(pdev->device, 7); ++i)
+		 */
+		for (i = GET_INDEX(pdev->device, 0); i <= GET_INDEX(pdev->device, 7); ++i)
 			quirk_aspm_offset[i] = 0;
 
 		pbus->ops = pbus->parent->ops;
@@ -286,17 +286,17 @@ static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 		list_for_each_entry(dev, &pbus->devices, bus_list) {
 			/* There are 0 to 8 devices attached to this bus */
 			cap_base = pci_find_capability(dev, PCI_CAP_ID_EXP);
-			quirk_aspm_offset[GET_INDEX(pdev->device, dev->devfn)]= cap_base + 0x10;
+			quirk_aspm_offset[GET_INDEX(pdev->device, dev->devfn)] = cap_base + 0x10;
 		}
 		pbus->ops = &quirk_pcie_aspm_ops;
 	}
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PA,	pcie_rootport_aspm_quirk );
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PA1,	pcie_rootport_aspm_quirk );
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PB,	pcie_rootport_aspm_quirk );
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PB1,	pcie_rootport_aspm_quirk );
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PC,	pcie_rootport_aspm_quirk );
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PC1,	pcie_rootport_aspm_quirk );
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PA,	pcie_rootport_aspm_quirk);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PA1,	pcie_rootport_aspm_quirk);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PB,	pcie_rootport_aspm_quirk);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PB1,	pcie_rootport_aspm_quirk);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PC,	pcie_rootport_aspm_quirk);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PC1,	pcie_rootport_aspm_quirk);
 
 /*
  * Fixup to mark boot BIOS video selected by BIOS before it changes
@@ -336,8 +336,8 @@ static void __devinit pci_fixup_video(struct pci_dev *pdev)
 		 * PCI header type NORMAL.
 		 */
 		if (bridge
-		    &&((bridge->hdr_type == PCI_HEADER_TYPE_BRIDGE)
-		       ||(bridge->hdr_type == PCI_HEADER_TYPE_CARDBUS))) {
+		    && ((bridge->hdr_type == PCI_HEADER_TYPE_BRIDGE)
+		       || (bridge->hdr_type == PCI_HEADER_TYPE_CARDBUS))) {
 			pci_read_config_word(bridge, PCI_BRIDGE_CONTROL,
 						&config);
 			if (!(config & PCI_BRIDGE_CTL_VGA))
-- 
1.5.4.rc2.17.g257f

