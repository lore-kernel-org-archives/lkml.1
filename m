Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZFTStc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZFTStc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbZFTSqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48151 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034AbZFTSqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 17/25] Blackfin: update defconfigs
Date: Sat, 20 Jun 2009 14:44:40 -0400
Message-Id: <1245523488-26536-18-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/configs/BF518F-EZBRD_defconfig |   24 ++++++++++++++--------
 arch/blackfin/configs/BF526-EZBRD_defconfig  |   22 +++++++++++---------
 arch/blackfin/configs/BF527-EZKIT_defconfig  |   22 +++++++++++++-------
 arch/blackfin/configs/BF533-EZKIT_defconfig  |   25 ++++++++++++++++-------
 arch/blackfin/configs/BF533-STAMP_defconfig  |   22 +++++++++++++-------
 arch/blackfin/configs/BF537-STAMP_defconfig  |   22 +++++++++++++-------
 arch/blackfin/configs/BF538-EZKIT_defconfig  |   22 +++++++++++++-------
 arch/blackfin/configs/BF548-EZKIT_defconfig  |   27 +++++++++++++++----------
 arch/blackfin/configs/BF561-EZKIT_defconfig  |   27 +++++++++++++++----------
 arch/blackfin/configs/BlackStamp_defconfig   |   12 ++++++++--
 arch/blackfin/configs/CM-BF527_defconfig     |   22 +++++++++++++-------
 arch/blackfin/configs/CM-BF533_defconfig     |   23 +++++++++++++--------
 arch/blackfin/configs/CM-BF537E_defconfig    |   22 +++++++++++++-------
 arch/blackfin/configs/CM-BF537U_defconfig    |   23 +++++++++++++--------
 arch/blackfin/configs/CM-BF548_defconfig     |   25 +++++++++++++++--------
 arch/blackfin/configs/CM-BF561_defconfig     |   25 +++++++++++++++--------
 arch/blackfin/configs/H8606_defconfig        |   14 +++++++++---
 arch/blackfin/configs/PNAV-10_defconfig      |   20 ++++++++++++------
 arch/blackfin/configs/SRV1_defconfig         |   14 +++++++++---
 arch/blackfin/configs/TCM-BF537_defconfig    |   14 +++++++++---
 20 files changed, 272 insertions(+), 155 deletions(-)

diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index baec133..dcfb488 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -326,11 +326,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -413,11 +419,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -916,7 +922,7 @@ CONFIG_MMC_BLOCK_BOUNCE=y
 # CONFIG_MMC_SDHCI is not set
 CONFIG_SDH_BFIN=m
 CONFIG_SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND=y
-CONFIG_SDH_BFIN_ENABLE_SDIO_IRQ=y
+# CONFIG_SDH_BFIN_ENABLE_SDIO_IRQ is not set
 # CONFIG_MMC_SPI is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
@@ -1147,7 +1153,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index c06262e..48a3a7a 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -331,16 +331,18 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-# CONFIG_MPU is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
 
 #
-# Asynchonous Memory Configuration
+# Memory Protection Unit
 #
+# CONFIG_MPU is not set
 
 #
 # EBIU_AMGCTL Global Control
@@ -418,11 +420,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1424,7 +1426,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index e9175c6..dd83527 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -331,11 +331,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -418,11 +424,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1505,7 +1511,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 5aa63ba..4c04480 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -292,12 +292,21 @@ CONFIG_DMA_UNCACHED_1M=y
 #
 # Cache Support
 #
+#
+# Cache Support
+#
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -391,11 +400,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1052,7 +1061,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index fed2532..c99bbcd 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -293,11 +293,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -391,11 +397,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1216,7 +1222,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index f9ac20d..092ffda 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -300,11 +300,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -399,11 +405,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1269,7 +1275,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index ee98e22..fa698a8 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -311,11 +311,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -398,11 +404,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1203,7 +1209,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index deeabef..b3d3cab 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -366,14 +366,19 @@ CONFIG_DMA_UNCACHED_2M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-# CONFIG_BFIN_L2_WB is not set
-CONFIG_BFIN_L2_WT=y
-# CONFIG_BFIN_L2_NOT_CACHED is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+# CONFIG_BFIN_L2_ICACHEABLE is not set
+# CONFIG_BFIN_L2_DCACHEABLE is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -459,11 +464,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1606,7 +1611,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index dcfbe2e..0313cd1 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -331,14 +331,19 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-# CONFIG_BFIN_L2_WB is not set
-CONFIG_BFIN_L2_WT=y
-# CONFIG_BFIN_L2_NOT_CACHED is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+# CONFIG_BFIN_L2_ICACHEABLE is not set
+# CONFIG_BFIN_L2_DCACHEABLE is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -425,11 +430,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1044,7 +1049,7 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 174c578..5d944ff 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -285,11 +285,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index e17875e..648a31d 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -329,11 +329,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -417,11 +423,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1246,7 +1252,7 @@ CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index fafd95e..ae665b9 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -262,12 +262,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-CONFIG_L1_MAX_PIECE=16
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -353,10 +358,10 @@ CONFIG_IP_FIB_HASH=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
-CONFIG_INET_DIAG=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -873,7 +878,7 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index e73aa5a..d74b6f4 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -297,11 +297,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -383,11 +389,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -861,7 +867,7 @@ CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_SECTION_MISMATCH=y
 # CONFIG_DEBUG_KERNEL is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index 8021130..7fc8dfa 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -270,12 +270,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-CONFIG_L1_MAX_PIECE=16
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -361,10 +366,10 @@ CONFIG_IP_FIB_HASH=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
-CONFIG_INET_DIAG=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -901,7 +906,7 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 CONFIG_DEBUG_BFIN_HWTRACE_ON=y
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index dd815f0..acca4e5 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -333,12 +333,19 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-CONFIG_L1_MAX_PIECE=16
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+# CONFIG_BFIN_L2_ICACHEABLE is not set
+# CONFIG_BFIN_L2_DCACHEABLE is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -428,11 +435,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -1334,7 +1341,7 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 16c198b..bae4ee6 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -308,12 +308,19 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-CONFIG_L1_MAX_PIECE=16
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+# CONFIG_BFIN_L2_ICACHEABLE is not set
+# CONFIG_BFIN_L2_DCACHEABLE is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -395,11 +402,11 @@ CONFIG_IP_FIB_HASH=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
@@ -837,7 +844,7 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_SAMPLES is not set
 CONFIG_DEBUG_MMRS=y
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index 6b4c1a9..a6a7c8e 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -258,12 +258,18 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-CONFIG_BFIN_ICACHE_LOCK=y
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-CONFIG_L1_MAX_PIECE=16
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
+# CONFIG_MPU is not set
 
 #
 # Asynchonous Memory Configuration
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index 09701f9..ff377fa 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -295,11 +295,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -382,11 +388,11 @@ CONFIG_IP_PNP=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
+# CONFIG_INET_DIAG is not set
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index ec84a53..814f9ca 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -279,12 +279,18 @@ CONFIG_DMA_UNCACHED_2M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
-CONFIG_L1_MAX_PIECE=16
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
+# CONFIG_MPU is not set
 
 #
 # Asynchonous Memory Configuration
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
index 6e27962..375e75a 100644
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -287,11 +287,17 @@ CONFIG_DMA_UNCACHED_1M=y
 # Cache Support
 #
 CONFIG_BFIN_ICACHE=y
+# CONFIG_BFIN_ICACHE_LOCK is not set
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
-# CONFIG_BFIN_ICACHE_LOCK is not set
-CONFIG_BFIN_WB=y
-# CONFIG_BFIN_WT is not set
+CONFIG_BFIN_EXTMEM_ICACHEABLE=y
+CONFIG_BFIN_EXTMEM_DCACHEABLE=y
+CONFIG_BFIN_EXTMEM_WRITEBACK=y
+# CONFIG_BFIN_EXTMEM_WRITETHROUGH is not set
+
+#
+# Memory Protection Unit
+#
 # CONFIG_MPU is not set
 
 #
@@ -709,7 +715,7 @@ CONFIG_FRAME_WARN=1024
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
-- 
1.6.3.1

