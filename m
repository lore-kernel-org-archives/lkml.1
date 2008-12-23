Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYLWAQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYLWAQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYLWAMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:34 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43699 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbYLWAM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:12:26 -0500
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
Subject: [PATCH -tip] Switch powerpc defconfig from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Date: Mon, 22 Dec 2008 16:12:25 -0800
Message-Id: <1229991147599-git-send-email-paulmck@linux.vnet.ibm.com>
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
 arch/powerpc/configs/adder875_defconfig     |    2 +-
 arch/powerpc/configs/c2k_defconfig          |    2 +-
 arch/powerpc/configs/cell_defconfig         |    2 +-
 arch/powerpc/configs/celleb_defconfig       |    2 +-
 arch/powerpc/configs/chrp32_defconfig       |    2 +-
 arch/powerpc/configs/ep8248e_defconfig      |    2 +-
 arch/powerpc/configs/ep88xc_defconfig       |    2 +-
 arch/powerpc/configs/g5_defconfig           |    2 +-
 arch/powerpc/configs/iseries_defconfig      |    2 +-
 arch/powerpc/configs/linkstation_defconfig  |    2 +-
 arch/powerpc/configs/maple_defconfig        |    2 +-
 arch/powerpc/configs/mgcoge_defconfig       |    2 +-
 arch/powerpc/configs/mgsuvd_defconfig       |    2 +-
 arch/powerpc/configs/mpc5200_defconfig      |    2 +-
 arch/powerpc/configs/mpc7448_hpc2_defconfig |    2 +-
 arch/powerpc/configs/mpc8272_ads_defconfig  |    2 +-
 arch/powerpc/configs/mpc83xx_defconfig      |    2 +-
 arch/powerpc/configs/mpc85xx_defconfig      |    2 +-
 arch/powerpc/configs/mpc866_ads_defconfig   |    2 +-
 arch/powerpc/configs/mpc86xx_defconfig      |    2 +-
 arch/powerpc/configs/mpc885_ads_defconfig   |    2 +-
 arch/powerpc/configs/pasemi_defconfig       |    2 +-
 arch/powerpc/configs/pmac32_defconfig       |    2 +-
 arch/powerpc/configs/ppc40x_defconfig       |    2 +-
 arch/powerpc/configs/ppc44x_defconfig       |    2 +-
 arch/powerpc/configs/ppc64_defconfig        |    2 +-
 arch/powerpc/configs/ppc6xx_defconfig       |    2 +-
 arch/powerpc/configs/pq2fads_defconfig      |    2 +-
 arch/powerpc/configs/prpmc2800_defconfig    |    2 +-
 arch/powerpc/configs/ps3_defconfig          |    2 +-
 arch/powerpc/configs/pseries_defconfig      |    2 +-
 arch/powerpc/configs/storcenter_defconfig   |    2 +-
 32 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
index 024f279..44a9c33 100644
--- a/arch/powerpc/configs/adder875_defconfig
+++ b/arch/powerpc/configs/adder875_defconfig
@@ -141,7 +141,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_defconfig
index 5078594..fdd2796 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -163,7 +163,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/cell_defconfig b/arch/powerpc/configs/cell_defconfig
index c420e47..2a0c357 100644
--- a/arch/powerpc/configs/cell_defconfig
+++ b/arch/powerpc/configs/cell_defconfig
@@ -155,7 +155,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Platform support
diff --git a/arch/powerpc/configs/celleb_defconfig b/arch/powerpc/configs/celleb_defconfig
index 9ba3c6f..b63cd4a 100644
--- a/arch/powerpc/configs/celleb_defconfig
+++ b/arch/powerpc/configs/celleb_defconfig
@@ -148,7 +148,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Platform support
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index 63b3c23..f43c2cb 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -157,7 +157,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/ep8248e_defconfig b/arch/powerpc/configs/ep8248e_defconfig
index a6f1cff..a69daca 100644
--- a/arch/powerpc/configs/ep8248e_defconfig
+++ b/arch/powerpc/configs/ep8248e_defconfig
@@ -139,7 +139,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
index 870d289..4d416fd 100644
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -140,7 +140,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index f85e71c..02e0ec5 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -162,7 +162,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 CONFIG_PPC_MSI_BITMAP=y
 
diff --git a/arch/powerpc/configs/iseries_defconfig b/arch/powerpc/configs/iseries_defconfig
index f925c55..affb125 100644
--- a/arch/powerpc/configs/iseries_defconfig
+++ b/arch/powerpc/configs/iseries_defconfig
@@ -160,7 +160,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/linkstation_defconfig b/arch/powerpc/configs/linkstation_defconfig
index 54fa624..4c68773 100644
--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -157,7 +157,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/maple_defconfig b/arch/powerpc/configs/maple_defconfig
index 045f1b0..04a93cb 100644
--- a/arch/powerpc/configs/maple_defconfig
+++ b/arch/powerpc/configs/maple_defconfig
@@ -158,7 +158,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 CONFIG_PPC_MSI_BITMAP=y
 
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
index 8d3c623..c8b2e66 100644
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -143,7 +143,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mgsuvd_defconfig b/arch/powerpc/configs/mgsuvd_defconfig
index fbaa67f..c80e2ce 100644
--- a/arch/powerpc/configs/mgsuvd_defconfig
+++ b/arch/powerpc/configs/mgsuvd_defconfig
@@ -139,7 +139,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mpc5200_defconfig b/arch/powerpc/configs/mpc5200_defconfig
index 15c5604..1e92faf 100644
--- a/arch/powerpc/configs/mpc5200_defconfig
+++ b/arch/powerpc/configs/mpc5200_defconfig
@@ -147,7 +147,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 CONFIG_FREEZER=y
 
 #
diff --git a/arch/powerpc/configs/mpc7448_hpc2_defconfig b/arch/powerpc/configs/mpc7448_hpc2_defconfig
index f80b1ca..7632280 100644
--- a/arch/powerpc/configs/mpc7448_hpc2_defconfig
+++ b/arch/powerpc/configs/mpc7448_hpc2_defconfig
@@ -144,7 +144,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mpc8272_ads_defconfig b/arch/powerpc/configs/mpc8272_ads_defconfig
index c8f5dec..49963eb 100644
--- a/arch/powerpc/configs/mpc8272_ads_defconfig
+++ b/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -140,7 +140,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mpc83xx_defconfig b/arch/powerpc/configs/mpc83xx_defconfig
index d582014..557601c 100644
--- a/arch/powerpc/configs/mpc83xx_defconfig
+++ b/arch/powerpc/configs/mpc83xx_defconfig
@@ -154,7 +154,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index c87b53a..506aad1 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -159,7 +159,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
index 8272b1a..09d7670 100644
--- a/arch/powerpc/configs/mpc866_ads_defconfig
+++ b/arch/powerpc/configs/mpc866_ads_defconfig
@@ -139,7 +139,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mpc86xx_defconfig b/arch/powerpc/configs/mpc86xx_defconfig
index 1736bbc..3dc03cc 100644
--- a/arch/powerpc/configs/mpc86xx_defconfig
+++ b/arch/powerpc/configs/mpc86xx_defconfig
@@ -159,7 +159,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index a4283b6..2c43aaf 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -140,7 +140,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index 199e5f5..90d1ae3 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -150,7 +150,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Platform support
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index de9b121..ff1f64b 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -158,7 +158,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 CONFIG_FREEZER=y
 
 #
diff --git a/arch/powerpc/configs/ppc40x_defconfig b/arch/powerpc/configs/ppc40x_defconfig
index 4256e2c..d55f2fc 100644
--- a/arch/powerpc/configs/ppc40x_defconfig
+++ b/arch/powerpc/configs/ppc40x_defconfig
@@ -151,7 +151,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 CONFIG_PPC4xx_PCI_EXPRESS=y
 
diff --git a/arch/powerpc/configs/ppc44x_defconfig b/arch/powerpc/configs/ppc44x_defconfig
index cfc94cf..fec4fe7 100644
--- a/arch/powerpc/configs/ppc44x_defconfig
+++ b/arch/powerpc/configs/ppc44x_defconfig
@@ -156,7 +156,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
 CONFIG_PREEMPT_NOTIFIERS=y
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 CONFIG_PPC4xx_PCI_EXPRESS=y
 
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 069ae1b..9921dda 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -176,7 +176,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 CONFIG_PPC_MSI_BITMAP=y
 
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 01f05ec..ce71c65 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -180,7 +180,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 CONFIG_FREEZER=y
 CONFIG_PPC_MSI_BITMAP=y
 
diff --git a/arch/powerpc/configs/pq2fads_defconfig b/arch/powerpc/configs/pq2fads_defconfig
index 228099d..bcd7ae6 100644
--- a/arch/powerpc/configs/pq2fads_defconfig
+++ b/arch/powerpc/configs/pq2fads_defconfig
@@ -141,7 +141,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/prpmc2800_defconfig b/arch/powerpc/configs/prpmc2800_defconfig
index 6046dc0..4775379 100644
--- a/arch/powerpc/configs/prpmc2800_defconfig
+++ b/arch/powerpc/configs/prpmc2800_defconfig
@@ -150,7 +150,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index b6eee7c..638cae2 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -157,7 +157,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Platform support
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 1e520ab..f4084b4 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -176,7 +176,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 CONFIG_FREEZER=y
 CONFIG_PPC_MSI_BITMAP=y
 
diff --git a/arch/powerpc/configs/storcenter_defconfig b/arch/powerpc/configs/storcenter_defconfig
index b3f5671..b7a5a33 100644
--- a/arch/powerpc/configs/storcenter_defconfig
+++ b/arch/powerpc/configs/storcenter_defconfig
@@ -148,7 +148,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
-- 
1.5.2.5

