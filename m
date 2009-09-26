Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbZIZQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbZIZQ6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZIZQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:58:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:49171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZIZQ6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:58:14 -0400
Subject: [PATCH] xtensa: Remove unused CONFIG XTENSA_ISS_NETWORK and
 XTENSA_UNALIGNED_USER
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Johannes Weiner <jw@emlix.com>, Chris Zankel <chris@zankel.net>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 22:23:19 +0530
Message-Id: <1253983999.4568.66.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed unused CONFIG XTENSA_ISS_NETWORK and XTENSA_UNALIGNED_USER from Kconfig and defconfigs

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/Kconfig                 |   13 -------------
 arch/xtensa/configs/iss_defconfig   |    2 --
 arch/xtensa/configs/s6105_defconfig |    2 --
 3 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ebe228d..328d0dd 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -83,15 +83,6 @@ config XTENSA_VARIANT_S6000
 	select XTENSA_CALIBRATE_CCOUNT
 endchoice
 
-config XTENSA_UNALIGNED_USER
-	bool "Unaligned memory access in use space"
-	help
-	  The Xtensa architecture currently does not handle unaligned
-	  memory accesses in hardware but through an exception handler.
-	  Per default, unaligned memory accesses are disabled in user space.
-
-	  Say Y here to enable unaligned memory access in user space.
-
 config PREEMPT
 	bool "Preemptible Kernel"
 	help
@@ -122,9 +113,6 @@ config XTENSA_CALIBRATE_CCOUNT
 config SERIAL_CONSOLE
 	def_bool n
 
-config XTENSA_ISS_NETWORK
-	def_bool n
-
 menu "Bus options"
 
 config PCI
@@ -150,7 +138,6 @@ config XTENSA_PLATFORM_ISS
 	bool "ISS"
 	select XTENSA_CALIBRATE_CCOUNT
 	select SERIAL_CONSOLE
-	select XTENSA_ISS_NETWORK
 	help
 	  ISS is an acronym for Tensilica's Instruction Set Simulator.
 
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index f198540..e6c1a29 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -55,7 +55,6 @@ CONFIG_CC_ALIGN_JUMPS=0
 #
 CONFIG_XTENSA_VARIANT_FSF=y
 CONFIG_MMU=y
-# CONFIG_XTENSA_UNALIGNED_USER is not set
 # CONFIG_PREEMPT is not set
 # CONFIG_MATH_EMULATION is not set
 # CONFIG_HIGHMEM is not set
@@ -72,7 +71,6 @@ CONFIG_XTENSA_CPU_CLOCK=10
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0,38400 eth0=tuntap,,tap0 ip=192.168.168.5:192.168.168.1 root=nfs nfsroot=192.168.168.1:/opt/montavista/pro/devkit/xtensa/linux_be/target"
 CONFIG_SERIAL_CONSOLE=y
-CONFIG_XTENSA_ISS_NETWORK=y
 
 #
 # Bus options
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index bb84fbc..bed2a49 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -111,13 +111,11 @@ CONFIG_VARIANT_IRQ_SWITCH=y
 # CONFIG_XTENSA_VARIANT_FSF is not set
 # CONFIG_XTENSA_VARIANT_DC232B is not set
 CONFIG_XTENSA_VARIANT_S6000=y
-# CONFIG_XTENSA_UNALIGNED_USER is not set
 CONFIG_PREEMPT=y
 # CONFIG_MATH_EMULATION is not set
 # CONFIG_HIGHMEM is not set
 CONFIG_XTENSA_CALIBRATE_CCOUNT=y
 CONFIG_SERIAL_CONSOLE=y
-# CONFIG_XTENSA_ISS_NETWORK is not set
 
 #
 # Bus options
-- 
1.6.0.6


