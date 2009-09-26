Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZIZNmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZIZNmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 09:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZIZNme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 09:42:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:49159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZIZNmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 09:42:33 -0400
Subject: [PATCH] ARM: Remove unused CONFIG ARCH_AT91SAM9260_SAM9XE
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Victor <linux@maxim.org.za>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 19:12:08 +0530
Message-Id: <1253972528.4568.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove unused CONFIG ARCH_AT91SAM9260_SAM9XE from Kconfig and defconfigs.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
---
 arch/arm/configs/afeb9260_defconfig      |    5 -----
 arch/arm/configs/at91sam9260ek_defconfig |    5 -----
 arch/arm/configs/cam60_defconfig         |    5 -----
 arch/arm/configs/cpu9260_defconfig       |    5 -----
 arch/arm/configs/qil-a9260_defconfig     |    5 -----
 arch/arm/configs/sam9_l9260_defconfig    |    5 -----
 arch/arm/configs/usb-a9260_defconfig     |    5 -----
 arch/arm/mach-at91/Kconfig               |    9 ---------
 8 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/arch/arm/configs/afeb9260_defconfig b/arch/arm/configs/afeb9260_defconfig
index f7a272c..f67a47a 100644
--- a/arch/arm/configs/afeb9260_defconfig
+++ b/arch/arm/configs/afeb9260_defconfig
@@ -193,11 +193,6 @@ CONFIG_ARCH_AT91SAM9260=y
 CONFIG_AT91_PMC_UNIT=y
 
 #
-# AT91SAM9260 Variants
-#
-# CONFIG_ARCH_AT91SAM9260_SAM9XE is not set
-
-#
 # AT91SAM9260 / AT91SAM9XE Board Type
 #
 # CONFIG_MACH_AT91SAM9260EK is not set
diff --git a/arch/arm/configs/at91sam9260ek_defconfig b/arch/arm/configs/at91sam9260ek_defconfig
index 98e2f3d..9f7f6bc 100644
--- a/arch/arm/configs/at91sam9260ek_defconfig
+++ b/arch/arm/configs/at91sam9260ek_defconfig
@@ -161,11 +161,6 @@ CONFIG_ARCH_AT91SAM9260=y
 CONFIG_AT91_PMC_UNIT=y
 
 #
-# AT91SAM9260 Variants
-#
-# CONFIG_ARCH_AT91SAM9260_SAM9XE is not set
-
-#
 # AT91SAM9260 / AT91SAM9XE Board Type
 #
 CONFIG_MACH_AT91SAM9260EK=y
diff --git a/arch/arm/configs/cam60_defconfig b/arch/arm/configs/cam60_defconfig
index 8448108..b4b2f9e 100644
--- a/arch/arm/configs/cam60_defconfig
+++ b/arch/arm/configs/cam60_defconfig
@@ -165,11 +165,6 @@ CONFIG_ARCH_AT91SAM9260=y
 CONFIG_AT91_PMC_UNIT=y
 
 #
-# AT91SAM9260 Variants
-#
-# CONFIG_ARCH_AT91SAM9260_SAM9XE is not set
-
-#
 # AT91SAM9260 / AT91SAM9XE Board Type
 #
 # CONFIG_MACH_AT91SAM9260EK is not set
diff --git a/arch/arm/configs/cpu9260_defconfig b/arch/arm/configs/cpu9260_defconfig
index 601e7f3..205380e 100644
--- a/arch/arm/configs/cpu9260_defconfig
+++ b/arch/arm/configs/cpu9260_defconfig
@@ -194,11 +194,6 @@ CONFIG_ARCH_AT91SAM9260=y
 CONFIG_AT91_PMC_UNIT=y
 
 #
-# AT91SAM9260 Variants
-#
-# CONFIG_ARCH_AT91SAM9260_SAM9XE is not set
-
-#
 # AT91SAM9260 / AT91SAM9XE Board Type
 #
 # CONFIG_MACH_AT91SAM9260EK is not set
diff --git a/arch/arm/configs/qil-a9260_defconfig b/arch/arm/configs/qil-a9260_defconfig
index 9b32d0e..6074142 100644
--- a/arch/arm/configs/qil-a9260_defconfig
+++ b/arch/arm/configs/qil-a9260_defconfig
@@ -161,11 +161,6 @@ CONFIG_ARCH_AT91SAM9260=y
 CONFIG_AT91_PMC_UNIT=y
 
 #
-# AT91SAM9260 Variants
-#
-# CONFIG_ARCH_AT91SAM9260_SAM9XE is not set
-
-#
 # AT91SAM9260 / AT91SAM9XE Board Type
 #
 # CONFIG_MACH_AT91SAM9260EK is not set
diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index 1174e27..29ae63a 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -150,11 +150,6 @@ CONFIG_ARCH_AT91SAM9260=y
 # CONFIG_ARCH_AT91SAM9RL is not set
 
 #
-# AT91SAM9260 Variants
-#
-# CONFIG_ARCH_AT91SAM9260_SAM9XE is not set
-
-#
 # AT91SAM9260 / AT91SAM9XE Board Type
 #
 # CONFIG_MACH_AT91SAM9260EK is not set
diff --git a/arch/arm/configs/usb-a9260_defconfig b/arch/arm/configs/usb-a9260_defconfig
index fd77740..12e1e08 100644
--- a/arch/arm/configs/usb-a9260_defconfig
+++ b/arch/arm/configs/usb-a9260_defconfig
@@ -161,11 +161,6 @@ CONFIG_ARCH_AT91SAM9260=y
 CONFIG_AT91_PMC_UNIT=y
 
 #
-# AT91SAM9260 Variants
-#
-# CONFIG_ARCH_AT91SAM9260_SAM9XE is not set
-
-#
 # AT91SAM9260 / AT91SAM9XE Board Type
 #
 # CONFIG_MACH_AT91SAM9260EK is not set
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index e35d54d..8b7d96d 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -169,15 +169,6 @@ endif
 
 if ARCH_AT91SAM9260
 
-comment "AT91SAM9260 Variants"
-
-config ARCH_AT91SAM9260_SAM9XE
-	bool "AT91SAM9XE"
-	depends on ARCH_AT91SAM9260
-	help
-	  Select this if you are using Atmel's AT91SAM9XE System-on-Chip.
-	  They are basically AT91SAM9260s with various sizes of embedded Flash.
-
 comment "AT91SAM9260 / AT91SAM9XE Board Type"
 
 config MACH_AT91SAM9260EK
-- 
1.6.0.6


