Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbXKUQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbXKUQQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXKUQQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:16:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597AbXKUQQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:16:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/9] AOUT: Mark arches that support A.OUT format
	[2.6.24-rc3-mm1]
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2007 16:16:37 +0000
Message-ID: <20071121161637.1097.76282.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071121161632.1097.9556.stgit@warthog.procyon.org.uk>
References: <20071121161632.1097.9556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark arches that support A.OUT format by including the following in their
master Kconfig files:

	config ARCH_SUPPORTS_AOUT
		def_bool y

This should also be set if the arch provides compatibility A.OUT support for
an older arch, for instance x86_64 for i386 or sparc64 for sparc.

I've guessed at which arches don't, based on comments in the code, however I'm
sure that some of the ones I've marked as 'yes' actually should be 'no'.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/Kconfig     |    3 +++
 arch/arm/Kconfig       |    3 +++
 arch/h8300/Kconfig     |    3 +++
 arch/m32r/Kconfig      |    3 +++
 arch/m68k/Kconfig      |    3 +++
 arch/m68knommu/Kconfig |    3 +++
 arch/parisc/Kconfig    |    3 +++
 arch/sh/Kconfig        |    3 +++
 arch/sh64/Kconfig      |    3 +++
 arch/sparc/Kconfig     |    3 +++
 arch/sparc64/Kconfig   |    5 ++++-
 arch/um/Kconfig.i386   |    2 ++
 arch/um/Kconfig.x86_64 |    2 ++
 arch/v850/Kconfig      |    3 +++
 arch/x86/Kconfig       |    5 ++++-
 15 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 4c002ba..92e0c9f 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -66,6 +66,9 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3504d26..de050c0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -114,6 +114,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index ff6a871..7009b0e 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -65,6 +65,9 @@ config TIME_LOW_RES
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 config NO_IOPORT
 	def_bool y
 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index ab9a264..7c96765 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -34,6 +34,9 @@ config NO_IOPORT
 config NO_DMA
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index ff1adfa..1143563 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -52,6 +52,9 @@ config NO_IOPORT
 config NO_DMA
 	def_bool SUN3
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index f4b582c..8de61df 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -60,6 +60,9 @@ config TIME_LOW_RES
 config NO_IOPORT
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b8ef178..da0dc3d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -69,6 +69,9 @@ config IRQ_PER_CPU
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 496d635..85381ba 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -93,6 +93,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System type"
diff --git a/arch/sh64/Kconfig b/arch/sh64/Kconfig
index 6884d5a..07e6ac4 100644
--- a/arch/sh64/Kconfig
+++ b/arch/sh64/Kconfig
@@ -58,6 +58,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source init/Kconfig
 
 menu "System type"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 527adc8..95d09b3 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -27,6 +27,9 @@ config ARCH_NO_VIRT_TO_BUS
 config OF
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "General machine setup"
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 10b212a..c9feb0e 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -76,6 +76,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
@@ -386,7 +389,7 @@ config BINFMT_ELF32
 
 config BINFMT_AOUT32
 	bool "Kernel support for 32-bit (ie. SunOS) a.out binaries"
-	depends on SPARC32_COMPAT
+	depends on SPARC32_COMPAT && ARCH_SUPPORTS_AOUT
 	help
 	  This allows you to run 32-bit a.out format binaries on your Ultra.
 	  If you want to run SunOS binaries (see SunOS binary emulation below)
diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index e0ac74e..a0af34e 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -77,3 +77,5 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
index d632e9a..b438f0e 100644
--- a/arch/um/Kconfig.x86_64
+++ b/arch/um/Kconfig.x86_64
@@ -39,3 +39,5 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index b6a50b8..dcf4b8e 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -53,6 +53,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 # Turn off some random 386 crap that can affect device config
 config ISA
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e3fec8b..6867b96 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -135,6 +135,9 @@ config AUDIT_ARCH
 	bool
 	default X86_64
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
@@ -1602,7 +1605,7 @@ config IA32_EMULATION
 
 config IA32_AOUT
        tristate "IA32 a.out support"
-       depends on IA32_EMULATION
+       depends on IA32_EMULATION && ARCH_SUPPORTS_AOUT
        help
          Support old a.out binaries in the 32bit emulation.
 

