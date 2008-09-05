Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbYIEQ1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbYIEQ1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYIEQ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:27:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:35060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYIEQ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:27:05 -0400
Subject: [PATCH 1/2] Remove redundant CONFIG_ARCH_SUPPORTS_AOUT
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1213696004.26255.960.camel@pmac.infradead.org>
References: <1213696004.26255.960.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 17:27:01 +0100
Message-Id: <1220632021.2985.360.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need this any more; arguably we never really did.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---

I think I meant to send these two in for 2.6.27 (since they weren't
suitable during 2.6.26-rc), but I forgot. So I'll queue them up for
2.6.28.

 arch/alpha/Kconfig     |    3 ---
 arch/arm/Kconfig       |    3 ---
 arch/h8300/Kconfig     |    3 ---
 arch/m32r/Kconfig      |    3 ---
 arch/m68k/Kconfig      |    3 ---
 arch/m68knommu/Kconfig |    3 ---
 arch/mn10300/Kconfig   |    3 ---
 arch/parisc/Kconfig    |    3 ---
 arch/um/Kconfig.i386   |    3 ---
 arch/um/Kconfig.x86_64 |    3 ---
 arch/x86/Kconfig       |    5 +----
 fs/Kconfig.binfmt      |    3 +--
 12 files changed, 2 insertions(+), 36 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 1bec55d..46f0ddf 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -68,9 +68,6 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 source "init/Kconfig"
 

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 70dba16..8803c39 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -140,9 +140,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 396ab05..107cb5b 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -66,9 +66,6 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 config NO_IOPORT
 	def_bool y
 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index a5f864c..8a165cc 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -36,9 +36,6 @@ config NO_IOPORT
 config NO_DMA
 	def_bool y
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 config HZ
 	int
 	default 100
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8c5e1de..d42b996 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -53,9 +53,6 @@ config NO_IOPORT
 config NO_DMA
 	def_bool SUN3
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 config HZ
 	int
 	default 100
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 2e7515e..0a89983 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -73,9 +73,6 @@ config GENERIC_CLOCKEVENTS
 config NO_IOPORT
 	def_bool y
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 source "init/Kconfig"
 
 menu "Processor type and features"
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index e856218..dd557c9 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -53,9 +53,6 @@ config QUICKLIST
 config ARCH_HAS_ILOG2_U32
 	def_bool y
 
-config ARCH_SUPPORTS_AOUT
-	def_bool n
-
 # Use the generic interrupt handling code in kernel/irq/
 config GENERIC_HARDIRQS
 	def_bool y
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index a7d4fd3..8313fcc 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -76,9 +76,6 @@ config IRQ_PER_CPU
 	bool
 	default y
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index e09edfa..2a44e5c 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -42,6 +42,3 @@ config ARCH_REUSE_HOST_VSYSCALL_AREA
 config GENERIC_HWEIGHT
 	bool
 	default y
-
-config ARCH_SUPPORTS_AOUT
-	def_bool y
diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
index 5696e7b..40b3407 100644
--- a/arch/um/Kconfig.x86_64
+++ b/arch/um/Kconfig.x86_64
@@ -37,6 +37,3 @@ config SMP_BROKEN
 config GENERIC_HWEIGHT
 	bool
 	default y
-
-config ARCH_SUPPORTS_AOUT
-	def_bool y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..2e8fa40 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -151,9 +151,6 @@ config AUDIT_ARCH
 	bool
 	default X86_64
 
-config ARCH_SUPPORTS_AOUT
-	def_bool y
-
 config ARCH_SUPPORTS_OPTIMIZED_INLINING
 	def_bool y
 
@@ -1759,7 +1756,7 @@ config IA32_EMULATION
 
 config IA32_AOUT
        tristate "IA32 a.out support"
-       depends on IA32_EMULATION && ARCH_SUPPORTS_AOUT
+       depends on IA32_EMULATION
        help
          Support old a.out binaries in the 32bit emulation.
 
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 4a551af..e4df913 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -61,8 +61,7 @@ config BINFMT_SHARED_FLAT
 
 config BINFMT_AOUT
 	tristate "Kernel support for a.out and ECOFF binaries"
-	depends on ARCH_SUPPORTS_AOUT && \
-		(X86_32 || ALPHA || ARM || M68K)
+	depends on (X86_32 || ALPHA || ARM || M68K)
 	---help---
 	  A.out (Assembler.OUTput) is a set of formats for libraries and
 	  executables used in the earliest versions of UNIX.  Linux used
-- 
1.5.5.1

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



