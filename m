Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbXKNATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbXKNATn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761190AbXKNAS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:18:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760911AbXKNASz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:18:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/9] AOUT: Mark arches that support A.OUT format [try #6]
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 14 Nov 2007 00:18:42 +0000
Message-ID: <20071114001842.27662.66081.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
References: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
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
 arch/avr32/Kconfig     |    3 +++
 arch/blackfin/Kconfig  |    3 +++
 arch/cris/Kconfig      |    3 +++
 arch/frv/Kconfig       |    3 +++
 arch/h8300/Kconfig     |    3 +++
 arch/ia64/Kconfig      |    3 +++
 arch/m32r/Kconfig      |    3 +++
 arch/m68k/Kconfig      |    3 +++
 arch/m68knommu/Kconfig |    3 +++
 arch/mips/Kconfig      |    3 +++
 arch/parisc/Kconfig    |    3 +++
 arch/powerpc/Kconfig   |    3 +++
 arch/ppc/Kconfig       |    3 +++
 arch/s390/Kconfig      |    3 +++
 arch/sh/Kconfig        |    3 +++
 arch/sh64/Kconfig      |    3 +++
 arch/sparc/Kconfig     |    3 +++
 arch/sparc64/Kconfig   |    3 +++
 arch/um/Kconfig.i386   |    2 ++
 arch/um/Kconfig.x86_64 |    2 ++
 arch/v850/Kconfig      |    3 +++
 arch/xtensa/Kconfig    |    3 +++
 24 files changed, 70 insertions(+), 0 deletions(-)

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
index a0cdaaf..ded0725 100644
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
 
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index bbecbd8..6ee54d9 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -70,6 +70,9 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "System Type and features"
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9f9de3e..b184c06 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -69,6 +69,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 config IRQCHIP_DEMUX_GPIO
 	bool
 	depends on (BF52x || BF53x || BF561 || BF54x)
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 21900a9..74ce4c1 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -47,6 +47,9 @@ config IRQ_PER_CPU
 config NO_IOPORT
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 config CRIS
 	bool
 	default y
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 43153e7..49056a9 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -57,6 +57,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 mainmenu "Fujitsu FR-V Kernel Configuration"
 
 source "init/Kconfig"
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
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index bef4772..02793f0 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -99,6 +99,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
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
index 01dee84..8d35d9d 100644
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
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 2c7d6c2..b6e0418 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -722,6 +722,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default n
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 #
 # Select some configuration options automatically based on user selections.
 #
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
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 18f397c..28931a0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -76,6 +76,9 @@ config GENERIC_FIND_NEXT_BIT
 config ARCH_NO_VIRT_TO_BUS
 	def_bool PPC64
 
+config ARCH_SUPPORTS_AOUT
+	def_bool y
+
 config PPC
 	bool
 	default y
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index 6473fa7..f389338 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -39,6 +39,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 config PPC
 	bool
 	default y
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 1330061..baa9287 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -47,6 +47,9 @@ config NO_IOMEM
 config NO_DMA
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 22a3eb3..d9e9512 100644
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
index 10b212a..5cafe37 100644
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
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index d3cb3d6..69295bd 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -49,6 +49,9 @@ config ARCH_HAS_ILOG2_U64
 config NO_IOPORT
 	def_bool y
 
+config ARCH_SUPPORTS_AOUT
+	def_bool n
+
 source "init/Kconfig"
 
 menu "Processor type and features"

