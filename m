Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYLWAPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYLWAPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYLWAMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:32 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50321 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbYLWAMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:12:25 -0500
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
Subject: [PATCH -tip] Switch mips defconfig from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Date: Mon, 22 Dec 2008 16:12:23 -0800
Message-Id: <122999114785-git-send-email-paulmck@linux.vnet.ibm.com>
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
 arch/mips/configs/bcm47xx_defconfig        |    2 +-
 arch/mips/configs/bigsur_defconfig         |    2 +-
 arch/mips/configs/cobalt_defconfig         |    2 +-
 arch/mips/configs/fulong_defconfig         |    2 +-
 arch/mips/configs/ip22_defconfig           |    2 +-
 arch/mips/configs/ip28_defconfig           |    2 +-
 arch/mips/configs/ip32_defconfig           |    2 +-
 arch/mips/configs/jmr3927_defconfig        |    2 +-
 arch/mips/configs/malta_defconfig          |    2 +-
 arch/mips/configs/pnx8335-stb225_defconfig |    2 +-
 arch/mips/configs/rb532_defconfig          |    2 +-
 arch/mips/configs/rbtx49xx_defconfig       |    2 +-
 arch/mips/configs/sb1250-swarm_defconfig   |    2 +-
 arch/mips/configs/tb0219_defconfig         |    2 +-
 arch/mips/configs/tb0226_defconfig         |    2 +-
 arch/mips/configs/tb0287_defconfig         |    2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index d869433..a85564a 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -245,7 +245,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_PREEMPT_RCU is not set
 
 #
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index a3bbbf0..07407f5 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -273,7 +273,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
index eb44b72..306ffa0 100644
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -242,7 +242,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/fulong_defconfig b/arch/mips/configs/fulong_defconfig
index b6698a2..4636f87 100644
--- a/arch/mips/configs/fulong_defconfig
+++ b/arch/mips/configs/fulong_defconfig
@@ -252,7 +252,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 CONFIG_FREEZER=y
 
 #
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index 1158228..1600dd8 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -259,7 +259,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/mips/configs/ip28_defconfig b/arch/mips/configs/ip28_defconfig
index 70a744e..932f093 100644
--- a/arch/mips/configs/ip28_defconfig
+++ b/arch/mips/configs/ip28_defconfig
@@ -247,7 +247,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_PREEMPT_RCU is not set
 
 #
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index de4c7a0..c3e5190 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -244,7 +244,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/mips/configs/jmr3927_defconfig b/arch/mips/configs/jmr3927_defconfig
index 9d5bd2a..e97ba5e 100644
--- a/arch/mips/configs/jmr3927_defconfig
+++ b/arch/mips/configs/jmr3927_defconfig
@@ -221,7 +221,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 1ecdd3b..bb6ee17 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -282,7 +282,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
diff --git a/arch/mips/configs/pnx8335-stb225_defconfig b/arch/mips/configs/pnx8335-stb225_defconfig
index d953652..524c779 100644
--- a/arch/mips/configs/pnx8335-stb225_defconfig
+++ b/arch/mips/configs/pnx8335-stb225_defconfig
@@ -242,7 +242,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index f28dc32..52d1ee5 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -241,7 +241,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
index c7c0864..b0c2cbb 100644
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -244,7 +244,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/sb1250-swarm_defconfig b/arch/mips/configs/sb1250-swarm_defconfig
index a9acaa2..ecf9b61 100644
--- a/arch/mips/configs/sb1250-swarm_defconfig
+++ b/arch/mips/configs/sb1250-swarm_defconfig
@@ -275,7 +275,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/tb0219_defconfig b/arch/mips/configs/tb0219_defconfig
index b505988..ceeb5a4 100644
--- a/arch/mips/configs/tb0219_defconfig
+++ b/arch/mips/configs/tb0219_defconfig
@@ -240,7 +240,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
index b06a716..15e5b10 100644
--- a/arch/mips/configs/tb0226_defconfig
+++ b/arch/mips/configs/tb0226_defconfig
@@ -240,7 +240,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
index 46512cf..87f5f3c 100644
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -239,7 +239,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, ISA, TC)
-- 
1.5.2.5

