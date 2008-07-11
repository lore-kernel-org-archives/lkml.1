Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbYGKLKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbYGKLKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYGKLCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:55 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37400 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbYGKLCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:52 -0400
X-BigFish: VPS23(zzzz10d3izz5a6ciz32i87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U9CD-01-XD1-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/2] x86/pci: renaming numa into numaq
Date: Fri, 11 Jul 2008 12:18:41 +0200
Message-ID: <1215771521-6848-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215771521-6848-1-git-send-email-robert.richter@amd.com>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 11:02:35.0851 (UTC) FILETIME=[A01C31B0:01C8E345]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/legacy.c   |    2 +-
 arch/x86/pci/numaq_32.c |    4 ++--
 arch/x86/pci/pci.h      |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 60e8caa..f405eb0 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -58,7 +58,7 @@ static int __init pci_legacy_init(void)
 int __init pci_subsys_init(void)
 {
 #ifdef CONFIG_X86_NUMAQ
-	pci_numa_init();
+	pci_numaq_init();
 #endif
 #ifdef CONFIG_ACPI
 	pci_acpi_init();
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 8b5ca19..f4b16dc 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -1,5 +1,5 @@
 /*
- * numa.c - Low-level PCI access for NUMA-Q machines
+ * numaq_32.c - Low-level PCI access for NUMA-Q machines
  */
 
 #include <linux/pci.h>
@@ -151,7 +151,7 @@ static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82451NX, pci_fixup_i450nx);
 
-int __init pci_numa_init(void)
+int __init pci_numaq_init(void)
 {
 	int quad;
 
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index b2270a5..36b8dd0 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -107,7 +107,7 @@ extern void __init dmi_check_skip_isa_align(void);
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
 extern int __init pcibios_irq_init(void);
-extern int __init pci_numa_init(void);
+extern int __init pci_numaq_init(void);
 extern int __init pcibios_init(void);
 
 /* pci-mmconfig.c */
-- 
1.5.5.4


