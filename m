Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbXFRIy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbXFRIy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbXFRIyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:54:49 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:36991 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753581AbXFRIys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:54:48 -0400
Message-id: <245108538110458337@wsc.cz>
In-reply-to: <29285162611339719891@wsc.cz>
Subject: [PATCH 2/5] i386: traps, change VENDOR to DEVICE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Date: Mon, 18 Jun 2007 10:54:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

traps, change VENDOR to DEVICE

Change macro for SGI lithium (arch/i386/mach-visws/traps.c) device from
VENDOR to DEVICE, because it's a device id.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2c144a8d6501ff8b137077b776df00423ca9ac19
tree a915ec153831006986b50960fa2303c8ef80e424
parent 96eaa9b8796ffe32733a4a25794854d8621433ee
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:31:06 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 18 Jun 2007 10:46:39 +0200

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
index 62eec56..a8d5830 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -947,8 +947,8 @@
 
 #define PCI_VENDOR_ID_SGI		0x10a9
 #define PCI_DEVICE_ID_SGI_IOC3		0x0003
+#define PCI_DEVICE_ID_SGI_LITHIUM	0x1002
 #define PCI_DEVICE_ID_SGI_IOC4		0x100a
-#define PCI_VENDOR_ID_SGI_LITHIUM	0x1002
 
 
 #define PCI_VENDOR_ID_WINBOND		0x10ad
