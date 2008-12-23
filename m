Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYLWANu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYLWANu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYLWAM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:27 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42931 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbYLWAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:12:24 -0500
From: paulmck@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       ralf@linux-mips.org, kernel@wantstofly.org, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] Switch arm defconfig files from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Date: Mon, 22 Dec 2008 16:12:17 -0800
Message-Id: <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Only for testing in -tip and -next, not yet for inclusion into mainline.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/arm/configs/afeb9260_defconfig     |    2 +-
 arch/arm/configs/am200epdkit_defconfig  |    2 +-
 arch/arm/configs/cm_x300_defconfig      |    2 +-
 arch/arm/configs/corgi_defconfig        |    2 +-
 arch/arm/configs/csb637_defconfig       |    2 +-
 arch/arm/configs/eseries_pxa_defconfig  |    2 +-
 arch/arm/configs/ezx_defconfig          |    2 +-
 arch/arm/configs/imx27ads_defconfig     |    2 +-
 arch/arm/configs/jornada720_defconfig   |    2 +-
 arch/arm/configs/kirkwood_defconfig     |    2 +-
 arch/arm/configs/loki_defconfig         |    2 +-
 arch/arm/configs/magician_defconfig     |    2 +-
 arch/arm/configs/mv78xx0_defconfig      |    2 +-
 arch/arm/configs/mx31ads_defconfig      |    2 +-
 arch/arm/configs/mx31litekit_defconfig  |    2 +-
 arch/arm/configs/omap3_beagle_defconfig |    2 +-
 arch/arm/configs/omap_h2_1610_defconfig |    2 +-
 arch/arm/configs/omap_ldp_defconfig     |    2 +-
 arch/arm/configs/orion5x_defconfig      |    2 +-
 arch/arm/configs/overo_defconfig        |    2 +-
 arch/arm/configs/palmz72_defconfig      |    2 +-
 arch/arm/configs/pcm037_defconfig       |    2 +-
 arch/arm/configs/pcm038_defconfig       |    2 +-
 arch/arm/configs/s3c2410_defconfig      |    2 +-
 arch/arm/configs/spitz_defconfig        |    2 +-
 arch/arm/configs/tct_hammer_defconfig   |    2 +-
 arch/arm/configs/viper_defconfig        |    2 +-
 arch/arm/configs/xm_x2xx_defconfig      |    2 +-
 28 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm/configs/afeb9260_defconfig b/arch/arm/configs/afeb9260_defconfig
index ce90958..d33451c 100644
--- a/arch/arm/configs/afeb9260_defconfig
+++ b/arch/arm/configs/afeb9260_defconfig
@@ -128,7 +128,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/am200epdkit_defconfig b/arch/arm/configs/am200epdkit_defconfig
index 5e68420..d6355df 100644
--- a/arch/arm/configs/am200epdkit_defconfig
+++ b/arch/arm/configs/am200epdkit_defconfig
@@ -116,7 +116,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index 46f1c9d..c7787bb 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -133,7 +133,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index 9876543..802975b 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -119,7 +119,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/csb637_defconfig b/arch/arm/configs/csb637_defconfig
index 9970214..8383c3b 100644
--- a/arch/arm/configs/csb637_defconfig
+++ b/arch/arm/configs/csb637_defconfig
@@ -120,7 +120,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/eseries_pxa_defconfig b/arch/arm/configs/eseries_pxa_defconfig
index 2307587..3030235 100644
--- a/arch/arm/configs/eseries_pxa_defconfig
+++ b/arch/arm/configs/eseries_pxa_defconfig
@@ -119,7 +119,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/ezx_defconfig b/arch/arm/configs/ezx_defconfig
index 2a84d55..e246493 100644
--- a/arch/arm/configs/ezx_defconfig
+++ b/arch/arm/configs/ezx_defconfig
@@ -120,7 +120,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/imx27ads_defconfig b/arch/arm/configs/imx27ads_defconfig
index bcd95b8..980fcdd 100644
--- a/arch/arm/configs/imx27ads_defconfig
+++ b/arch/arm/configs/imx27ads_defconfig
@@ -114,7 +114,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/jornada720_defconfig b/arch/arm/configs/jornada720_defconfig
index 81fadaf..1f5bf9b 100644
--- a/arch/arm/configs/jornada720_defconfig
+++ b/arch/arm/configs/jornada720_defconfig
@@ -126,7 +126,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
index e3357ba..df8941c 100644
--- a/arch/arm/configs/kirkwood_defconfig
+++ b/arch/arm/configs/kirkwood_defconfig
@@ -116,7 +116,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/loki_defconfig b/arch/arm/configs/loki_defconfig
index 17da7c3..ee097e3 100644
--- a/arch/arm/configs/loki_defconfig
+++ b/arch/arm/configs/loki_defconfig
@@ -113,7 +113,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index 4d11678..7362526 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -103,7 +103,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_PREEMPT_RCU is not set
 
 #
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index d38ebf8..32a5f04 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -117,7 +117,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/mx31ads_defconfig b/arch/arm/configs/mx31ads_defconfig
index e052717..66d48d8 100644
--- a/arch/arm/configs/mx31ads_defconfig
+++ b/arch/arm/configs/mx31ads_defconfig
@@ -119,7 +119,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/mx31litekit_defconfig b/arch/arm/configs/mx31litekit_defconfig
index 4f41c41..2f7b5c7 100644
--- a/arch/arm/configs/mx31litekit_defconfig
+++ b/arch/arm/configs/mx31litekit_defconfig
@@ -116,7 +116,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/omap3_beagle_defconfig b/arch/arm/configs/omap3_beagle_defconfig
index e042d27..0ad909b 100644
--- a/arch/arm/configs/omap3_beagle_defconfig
+++ b/arch/arm/configs/omap3_beagle_defconfig
@@ -127,7 +127,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/omap_h2_1610_defconfig b/arch/arm/configs/omap_h2_1610_defconfig
index c035072..3f0e812 100644
--- a/arch/arm/configs/omap_h2_1610_defconfig
+++ b/arch/arm/configs/omap_h2_1610_defconfig
@@ -117,7 +117,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_PREEMPT_RCU is not set
 
 #
diff --git a/arch/arm/configs/omap_ldp_defconfig b/arch/arm/configs/omap_ldp_defconfig
index 948a212..dd7c822 100644
--- a/arch/arm/configs/omap_ldp_defconfig
+++ b/arch/arm/configs/omap_ldp_defconfig
@@ -124,7 +124,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index b2456ca..ff95936 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -124,7 +124,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/overo_defconfig b/arch/arm/configs/overo_defconfig
index 4920096..ad41df3 100644
--- a/arch/arm/configs/overo_defconfig
+++ b/arch/arm/configs/overo_defconfig
@@ -131,7 +131,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/palmz72_defconfig b/arch/arm/configs/palmz72_defconfig
index 3245f8f..374dfd2 100644
--- a/arch/arm/configs/palmz72_defconfig
+++ b/arch/arm/configs/palmz72_defconfig
@@ -128,7 +128,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/pcm037_defconfig b/arch/arm/configs/pcm037_defconfig
index 6274745..5217846 100644
--- a/arch/arm/configs/pcm037_defconfig
+++ b/arch/arm/configs/pcm037_defconfig
@@ -119,7 +119,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/pcm038_defconfig b/arch/arm/configs/pcm038_defconfig
index 6b798c2..691774d 100644
--- a/arch/arm/configs/pcm038_defconfig
+++ b/arch/arm/configs/pcm038_defconfig
@@ -119,7 +119,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 35faaea..ff42b35 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -119,7 +119,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 4df5b4d..2407ea6 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -119,7 +119,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 07dfb98..d961e76 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -111,7 +111,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/viper_defconfig b/arch/arm/configs/viper_defconfig
index d01fecb..ac8a7e2 100644
--- a/arch/arm/configs/viper_defconfig
+++ b/arch/arm/configs/viper_defconfig
@@ -123,7 +123,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
diff --git a/arch/arm/configs/xm_x2xx_defconfig b/arch/arm/configs/xm_x2xx_defconfig
index f891364..f630bd9 100644
--- a/arch/arm/configs/xm_x2xx_defconfig
+++ b/arch/arm/configs/xm_x2xx_defconfig
@@ -128,7 +128,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # System Type
-- 
1.5.2.5

