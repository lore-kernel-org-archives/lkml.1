Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbXFPPrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbXFPPrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXFPPqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:46:54 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:35376 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751737AbXFPPqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:46:53 -0400
Message-id: <304222026973675436@wsc.cz>
In-reply-to: <116342983010020429@wsc.cz>
Subject: [PATCH 4/6] i386: traps, change VENDOR to DEVICE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 16 Jun 2007 17:46:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

traps, change VENDOR to DEVICE

Change macro for SGI lithium (arch/i386/mach-visws/traps.c) device from
VENDOR to DEVICE, because it's a device id.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2438fcec127e3c3fede4f712154a25c2fd4af560
tree f61a928bd27787b56c0b2dfba3abaef1a810eff8
parent 0046e56e3fb82170d030ae35aceecce9a87f1bfa
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:31:06 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:31:06 +0200

 arch/i386/mach-visws/traps.c |    4 ++--
 include/linux/pci_ids.h      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/i386/mach-visws/traps.c b/arch/i386/mach-visws/traps.c
index 5199bd0..843b67a 100644
--- a/arch/i386/mach-visws/traps.c
+++ b/arch/i386/mach-visws/traps.c
@@ -23,13 +23,13 @@ static __init void lithium_init(void)
 	set_fixmap(FIX_LI_PCIB, LI_PCI_B_PHYS);
 
 	if ((li_pcia_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
-	    (li_pcia_read16(PCI_DEVICE_ID) != PCI_VENDOR_ID_SGI_LITHIUM)) {
+	    (li_pcia_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
 		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'A');
 		panic("This machine is not SGI Visual Workstation 320/540");
 	}
 
 	if ((li_pcib_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
-	    (li_pcib_read16(PCI_DEVICE_ID) != PCI_VENDOR_ID_SGI_LITHIUM)) {
+	    (li_pcib_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
 		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'B');
 		panic("This machine is not SGI Visual Workstation 320/540");
 	}
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index df25c8a..6126078 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -937,8 +937,8 @@
 
 #define PCI_VENDOR_ID_SGI		0x10a9
 #define PCI_DEVICE_ID_SGI_IOC3		0x0003
+#define PCI_DEVICE_ID_SGI_LITHIUM	0x1002
 #define PCI_DEVICE_ID_SGI_IOC4		0x100a
-#define PCI_VENDOR_ID_SGI_LITHIUM	0x1002
 
 #define PCI_VENDOR_ID_WINBOND		0x10ad
 #define PCI_DEVICE_ID_WINBOND_82C105	0x0105
