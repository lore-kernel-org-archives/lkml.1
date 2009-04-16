Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZDPKD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZDPKD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZDPKDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:03:11 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54407 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757267AbZDPKDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:03:10 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
Date: Thu, 16 Apr 2009 11:56:38 +0200
Message-Id: <74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <c92f8e48fb760c385438885b4a2c79c50a213f3b.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
 <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
 <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu>
 <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu>
 <c92f8e48fb760c385438885b4a2c79c50a213f3b.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/block/Kconfig |    2 +-
 drivers/char/Kconfig  |    2 +-
 drivers/gpio/Kconfig  |    2 +-
 drivers/usb/Kconfig   |    1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index ddea8e4..9f1665f 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -438,7 +438,7 @@ source "drivers/s390/block/Kconfig"
 
 config XILINX_SYSACE
 	tristate "Xilinx SystemACE support"
-	depends on 4xx
+	depends on 4xx || MICROBLAZE
 	help
 	  Include support for the Xilinx SystemACE CompactFlash interface
 
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 735bbe2..bb1a071 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -893,7 +893,7 @@ config DTLK
 
 config XILINX_HWICAP
 	tristate "Xilinx HWICAP Support"
-	depends on XILINX_VIRTEX
+	depends on XILINX_VIRTEX || MICROBLAZE
 	help
 	  This option enables support for Xilinx Internal Configuration
 	  Access Port (ICAP) driver.  The ICAP is used on Xilinx Virtex
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index edb0253..11f3739 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -69,7 +69,7 @@ comment "Memory mapped GPIO expanders:"
 
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
-	depends on PPC_OF
+	depends on PPC_OF || MICROBLAZE
 	help
 	  Say yes here to support the Xilinx FPGA GPIO device
 
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index c6c816b..5eee3f8 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -22,6 +22,7 @@ config USB_ARCH_HAS_HCD
 	default y if PCMCIA && !M32R			# sl811_cs
 	default y if ARM				# SL-811
 	default y if SUPERH				# r8a66597-hcd
+	default y if MICROBLAZE
 	default PCI
 
 # many non-PCI SOC chips embed OHCI
-- 
1.5.5.1

