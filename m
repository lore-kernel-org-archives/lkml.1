Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXKCXt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXKCXt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXKCXto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:49:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52685 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043AbXKCXtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:49:43 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 05/10] x86: add X86_64 dependency to x86_64 specific symbols in Kconig.x86_64
Date: Sun,  4 Nov 2007 00:51:15 +0100
Message-Id: <11941338802646-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11941338802525-git-send-email-sam@ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org> <11941338802525-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To ease unification of Kconfig.i386 and Kconfig.x86_64
add X86_64 dependencies to all x86_64 specific symbols.

This patch introduce no functional changes but is one step
towards unification. This smaller step is used to ease
review of the patch set.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig.x86_64 |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index 9fd69a0..5b7ada6 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -151,7 +151,7 @@ config X86_PC
 
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
-	depends on PCI
+	depends on X86_64 && PCI
 	 help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -297,7 +297,7 @@ config NUMA
 
 config K8_NUMA
        bool "Old style AMD Opteron NUMA detection"
-       depends on NUMA && PCI
+       depends on X86_64 && NUMA && PCI
        default y
        help
 	 Enable K8 NUMA node topology detection.  You should say Y here if
@@ -315,7 +315,7 @@ config NODES_SHIFT
 
 config X86_64_ACPI_NUMA
        bool "ACPI NUMA detection"
-       depends on NUMA
+       depends on X86_64 && NUMA
        select ACPI 
 	select PCI
        select ACPI_NUMA
@@ -325,7 +325,7 @@ config X86_64_ACPI_NUMA
 
 config NUMA_EMU
 	bool "NUMA emulation"
-	depends on NUMA
+	depends on X86_64 && NUMA
 	help
 	  Enable NUMA emulation. A flat machine will be split
 	  into virtual nodes when booted with "numa=fake=N", where N is the
@@ -421,7 +421,7 @@ config GART_IOMMU
 	default y
 	select SWIOTLB
 	select AGP
-	depends on PCI
+	depends on X86_64 && PCI
 	help
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -436,7 +436,7 @@ config GART_IOMMU
 config CALGARY_IOMMU
 	bool "IBM Calgary IOMMU support"
 	select SWIOTLB
-	depends on PCI && EXPERIMENTAL
+	depends on X86_64 && PCI && EXPERIMENTAL
 	help
 	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
 	  systems. Needed to run systems with more than 3GB of memory
@@ -483,7 +483,7 @@ config X86_MCE
 
 config X86_MCE_INTEL
 	bool "Intel MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
 	default y
 	help
 	   Additional support for intel specific MCE features such as
@@ -491,7 +491,7 @@ config X86_MCE_INTEL
 
 config X86_MCE_AMD
 	bool "AMD MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
 	default y
 	help
 	   Additional support for AMD specific MCE features such as
@@ -598,7 +598,7 @@ config SECCOMP
 
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on X86_64 && EXPERIMENTAL
 	help
          This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of critical functions, a canary
-- 
1.5.3.4.1157.g0e74-dirty

