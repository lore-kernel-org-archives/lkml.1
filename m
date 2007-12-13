Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbXLMSpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbXLMSpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763847AbXLMSpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:45:17 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33415 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762901AbXLMSpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:45:14 -0500
Date: Thu, 13 Dec 2007 19:45:17 +0100
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] Kconfig help: don't refer to the PCI-HOWTO
Message-ID: <20071213184517.GD21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A HOWTO that hasn't been updated for half a dozen years no longer
"contains valuable information about which PCI hardware does work under 
Linux and which doesn't".

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/alpha/Kconfig          |    5 -----
 arch/arm/Kconfig            |    5 -----
 arch/frv/Kconfig            |    5 -----
 arch/m32r/Kconfig           |    5 -----
 arch/m68k/Kconfig           |    5 -----
 arch/mips/Kconfig           |    5 -----
 arch/sh/drivers/pci/Kconfig |    5 -----
 arch/sh64/Kconfig           |    5 -----
 arch/sparc64/Kconfig        |    5 -----
 arch/x86/Kconfig            |    5 -----
 arch/xtensa/Kconfig         |    5 -----
 11 files changed, 55 deletions(-)

9e7dc1c05be01e514b8d512354b9cbd32c66a7c3 
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 4c002ba..c613d5f 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -318,11 +318,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_DOMAINS
 	bool
 	default y
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a7e9fea..1d23ac4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -544,11 +544,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_SYSCALL
 	def_bool PCI
 
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 43153e7..afb19b0 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -322,11 +322,6 @@ config PCI
 	  onboard. If you have one of these boards and you wish to use the PCI
 	  facilities, say Y here.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config RESERVE_DMA_COHERENT
 	bool "Reserve DMA coherent memory"
 	depends on PCI && !MMU
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index ab9a264..95d3e32 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -354,11 +354,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 choice
 	prompt "PCI access mode"
 	depends on PCI
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 01dee84..24e6bc0 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -145,11 +145,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config MAC
 	bool "Macintosh support"
 	depends on !MMU_SUN3
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index c6fc405..4339e6f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1918,11 +1918,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, or VESA. If you have PCI,
 	  say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_DOMAINS
 	bool
 
diff --git a/arch/sh/drivers/pci/Kconfig b/arch/sh/drivers/pci/Kconfig
index fbc6f2c..7e816ed 100644
--- a/arch/sh/drivers/pci/Kconfig
+++ b/arch/sh/drivers/pci/Kconfig
@@ -6,11 +6,6 @@ config PCI
 	  bus system, i.e. the way the CPU talks to the other stuff inside
 	  your box. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config SH_PCIDMA_NONCOHERENT
 	bool "Cache and PCI noncoherent"
 	depends on PCI
diff --git a/arch/sh64/Kconfig b/arch/sh64/Kconfig
index 6884d5a..f3b7c83 100644
--- a/arch/sh64/Kconfig
+++ b/arch/sh64/Kconfig
@@ -247,11 +247,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config SH_PCIDMA_NONCOHERENT
 	bool "Cache and PCI noncoherent"
 	depends on PCI
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 10b212a..ce4f552 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -343,11 +343,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 config PCI_DOMAINS
 	def_bool PCI
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2897cc0..88cbc59 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1379,11 +1379,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
 choice
 	prompt "PCI access mode"
 	depends on X86_32 && PCI && !X86_VISWS
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index d3cb3d6..844721e 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -174,11 +174,6 @@ config PCI
 	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 	  VESA. If you have PCI, say Y, otherwise N.
 
-	  The PCI-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't
-
 source "drivers/pci/Kconfig"
 
 config HOTPLUG

