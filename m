Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbYAaABO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbYAaABO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYAaAA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:00:59 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:63744 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYAaAAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:00:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=D9GEC3EIHln5cHysOvIbYswxBIxVq48GEv9Rei+hgwkpE4WTewrpvSjnoJ5+voIUN5w48EdbvPcxDBeyAnRLwLLf2ce3aL63Urb7n6PWKq3swPTWxX82iGwmbQSXzPYlaRWOUdHHtzPvMwalcQCSiPeWfJbUzdfzCc2fumU4SeM=
Subject: [PATCH trivial] Remove CONFIG_FORCED_INLINING
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080130145034.194a0366@laptopd505.fenrus.org>
References: <590657100801301437xdf2d140p7a54f90f345022ba@mail.gmail.com>
	 <20080130145034.194a0366@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 16:00:31 -0800
Message-Id: <1201737631.8837.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than the defconfigs, remove the entry in compiler-gcc4.h,
Kconfig.debug and feature-removal-schedule.txt.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 Documentation/feature-removal-schedule.txt  |    9 ---------
 arch/arm/configs/at91cap9adk_defconfig      |    1 -
 arch/arm/configs/at91sam9260ek_defconfig    |    1 -
 arch/arm/configs/at91sam9261ek_defconfig    |    1 -
 arch/arm/configs/at91sam9263ek_defconfig    |    1 -
 arch/arm/configs/at91sam9rlek_defconfig     |    1 -
 arch/arm/configs/cm_x270_defconfig          |    1 -
 arch/arm/configs/colibri_defconfig          |    1 -
 arch/arm/configs/collie_defconfig           |    1 -
 arch/arm/configs/em_x270_defconfig          |    1 -
 arch/arm/configs/ep93xx_defconfig           |    1 -
 arch/arm/configs/iop32x_defconfig           |    1 -
 arch/arm/configs/iop33x_defconfig           |    1 -
 arch/arm/configs/ixp2000_defconfig          |    1 -
 arch/arm/configs/ixp23xx_defconfig          |    1 -
 arch/arm/configs/ks8695_defconfig           |    1 -
 arch/arm/configs/littleton_defconfig        |    1 -
 arch/arm/configs/lpd270_defconfig           |    1 -
 arch/arm/configs/lpd7a404_defconfig         |    1 -
 arch/arm/configs/msm_defconfig              |    1 -
 arch/arm/configs/netx_defconfig             |    1 -
 arch/arm/configs/ns9xxx_defconfig           |    1 -
 arch/arm/configs/onearm_defconfig           |    1 -
 arch/arm/configs/picotux200_defconfig       |    1 -
 arch/arm/configs/pnx4008_defconfig          |    1 -
 arch/arm/configs/realview-smp_defconfig     |    1 -
 arch/arm/configs/rpc_defconfig              |    1 -
 arch/arm/configs/s3c2410_defconfig          |    1 -
 arch/arm/configs/versatile_defconfig        |    1 -
 arch/avr32/configs/atngw100_defconfig       |    1 -
 arch/avr32/configs/atstk1002_defconfig      |    1 -
 arch/avr32/configs/atstk1003_defconfig      |    1 -
 arch/ia64/configs/bigsur_defconfig          |    1 -
 arch/ia64/configs/gensparse_defconfig       |    1 -
 arch/ia64/configs/sim_defconfig             |    1 -
 arch/ia64/configs/sn2_defconfig             |    1 -
 arch/ia64/configs/tiger_defconfig           |    1 -
 arch/ia64/configs/zx1_defconfig             |    1 -
 arch/ia64/defconfig                         |    1 -
 arch/m32r/configs/opsput_defconfig          |    1 -
 arch/m32r/configs/usrv_defconfig            |    1 -
 arch/mips/configs/bigsur_defconfig          |    1 -
 arch/mips/configs/mipssim_defconfig         |    1 -
 arch/mips/configs/msp71xx_defconfig         |    1 -
 arch/mips/configs/pnx8550-jbs_defconfig     |    1 -
 arch/mips/configs/pnx8550-stb810_defconfig  |    1 -
 arch/mips/configs/yosemite_defconfig        |    1 -
 arch/parisc/configs/712_defconfig           |    1 -
 arch/parisc/configs/a500_defconfig          |    1 -
 arch/parisc/configs/b180_defconfig          |    1 -
 arch/parisc/configs/c3000_defconfig         |    1 -
 arch/parisc/defconfig                       |    1 -
 arch/powerpc/configs/bamboo_defconfig       |    1 -
 arch/powerpc/configs/cell_defconfig         |    1 -
 arch/powerpc/configs/celleb_defconfig       |    1 -
 arch/powerpc/configs/chrp32_defconfig       |    1 -
 arch/powerpc/configs/ebony_defconfig        |    1 -
 arch/powerpc/configs/ep88xc_defconfig       |    1 -
 arch/powerpc/configs/g5_defconfig           |    1 -
 arch/powerpc/configs/holly_defconfig        |    1 -
 arch/powerpc/configs/iseries_defconfig      |    1 -
 arch/powerpc/configs/kilauea_defconfig      |    1 -
 arch/powerpc/configs/linkstation_defconfig  |    1 -
 arch/powerpc/configs/lite5200_defconfig     |    1 -
 arch/powerpc/configs/maple_defconfig        |    1 -
 arch/powerpc/configs/mpc8272_ads_defconfig  |    1 -
 arch/powerpc/configs/mpc8313_rdb_defconfig  |    1 -
 arch/powerpc/configs/mpc8540_ads_defconfig  |    1 -
 arch/powerpc/configs/mpc8544_ds_defconfig   |    1 -
 arch/powerpc/configs/mpc8560_ads_defconfig  |    1 -
 arch/powerpc/configs/mpc8568mds_defconfig   |    1 -
 arch/powerpc/configs/mpc8572_ds_defconfig   |    1 -
 arch/powerpc/configs/mpc85xx_cds_defconfig  |    1 -
 arch/powerpc/configs/mpc8610_hpcd_defconfig |    1 -
 arch/powerpc/configs/mpc8641_hpcn_defconfig |    1 -
 arch/powerpc/configs/mpc885_ads_defconfig   |    1 -
 arch/powerpc/configs/pasemi_defconfig       |    1 -
 arch/powerpc/configs/pmac32_defconfig       |    1 -
 arch/powerpc/configs/ppc64_defconfig        |    1 -
 arch/powerpc/configs/pq2fads_defconfig      |    1 -
 arch/powerpc/configs/ps3_defconfig          |    1 -
 arch/powerpc/configs/pseries_defconfig      |    1 -
 arch/powerpc/configs/sequoia_defconfig      |    1 -
 arch/powerpc/configs/walnut_defconfig       |    1 -
 arch/ppc/configs/ml300_defconfig            |    1 -
 arch/ppc/configs/ml403_defconfig            |    1 -
 arch/ppc/configs/prep_defconfig             |    1 -
 arch/ppc/configs/taishan_defconfig          |    1 -
 arch/s390/defconfig                         |    1 -
 arch/sh/configs/cayman_defconfig            |    1 -
 arch/sh/configs/magicpanelr2_defconfig      |    1 -
 arch/sh/configs/r7780mp_defconfig           |    1 -
 arch/sh/configs/r7785rp_defconfig           |    1 -
 arch/sh/configs/sdk7780_defconfig           |    1 -
 arch/sh/configs/se7206_defconfig            |    1 -
 arch/sh/configs/se7712_defconfig            |    1 -
 arch/sh/configs/shx3_defconfig              |    1 -
 arch/sh/configs/titan_defconfig             |    1 -
 arch/sparc/defconfig                        |    1 -
 arch/sparc64/defconfig                      |    1 -
 arch/um/defconfig                           |    1 -
 arch/x86/configs/i386_defconfig             |    1 -
 arch/x86/configs/x86_64_defconfig           |    1 -
 include/linux/compiler-gcc4.h               |    9 ---------
 lib/Kconfig.debug                           |   14 --------------
 105 files changed, 0 insertions(+), 134 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 181bff0..3a46d1f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -130,15 +130,6 @@ Who:	Christoph Hellwig <hch@lst.de>
 
 ---------------------------
 
-What:	CONFIG_FORCED_INLINING
-When:	June 2006
-Why:	Config option is there to see if gcc is good enough. (in january
-        2006). If it is, the behavior should just be the default. If it's not,
-	the option should just go away entirely.
-Who:    Arjan van de Ven
-
----------------------------
-
 What:   eepro100 network driver
 When:   January 2007
 Why:    replaced by the e100 driver
diff --git a/arch/arm/configs/at91cap9adk_defconfig b/arch/arm/configs/at91cap9adk_defconfig
index e32e736..e0ed8ca 100644
--- a/arch/arm/configs/at91cap9adk_defconfig
+++ b/arch/arm/configs/at91cap9adk_defconfig
@@ -1108,7 +1108,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/arm/configs/at91sam9260ek_defconfig b/arch/arm/configs/at91sam9260ek_defconfig
index 46b0c73..a730cfb 100644
--- a/arch/arm/configs/at91sam9260ek_defconfig
+++ b/arch/arm/configs/at91sam9260ek_defconfig
@@ -919,7 +919,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/at91sam9261ek_defconfig b/arch/arm/configs/at91sam9261ek_defconfig
index fcd8fa0..f2f688e 100644
--- a/arch/arm/configs/at91sam9261ek_defconfig
+++ b/arch/arm/configs/at91sam9261ek_defconfig
@@ -1075,7 +1075,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/at91sam9263ek_defconfig b/arch/arm/configs/at91sam9263ek_defconfig
index c72ab82..3eb980a 100644
--- a/arch/arm/configs/at91sam9263ek_defconfig
+++ b/arch/arm/configs/at91sam9263ek_defconfig
@@ -1153,7 +1153,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 # CONFIG_DEBUG_ERRORS is not set
diff --git a/arch/arm/configs/at91sam9rlek_defconfig b/arch/arm/configs/at91sam9rlek_defconfig
index fbe8b30..557ffab 100644
--- a/arch/arm/configs/at91sam9rlek_defconfig
+++ b/arch/arm/configs/at91sam9rlek_defconfig
@@ -924,7 +924,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/cm_x270_defconfig b/arch/arm/configs/cm_x270_defconfig
index 5cab083..31df3a4 100644
--- a/arch/arm/configs/cm_x270_defconfig
+++ b/arch/arm/configs/cm_x270_defconfig
@@ -1342,7 +1342,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/colibri_defconfig b/arch/arm/configs/colibri_defconfig
index c3e3418..0e46c7d 100644
--- a/arch/arm/configs/colibri_defconfig
+++ b/arch/arm/configs/colibri_defconfig
@@ -1399,7 +1399,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 4264e27..0b0ccac 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -930,7 +930,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_DEBUG_USER is not set
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 6bea090..b074f0e 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -1189,7 +1189,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 24a701a..9e8867e 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -1193,7 +1193,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/iop32x_defconfig b/arch/arm/configs/iop32x_defconfig
index 83f40d4..36e0665 100644
--- a/arch/arm/configs/iop32x_defconfig
+++ b/arch/arm/configs/iop32x_defconfig
@@ -1308,7 +1308,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/arm/configs/iop33x_defconfig b/arch/arm/configs/iop33x_defconfig
index 917afb5..ee6fb58 100644
--- a/arch/arm/configs/iop33x_defconfig
+++ b/arch/arm/configs/iop33x_defconfig
@@ -1051,7 +1051,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/arm/configs/ixp2000_defconfig b/arch/arm/configs/ixp2000_defconfig
index f8f9793..c0290bf 100644
--- a/arch/arm/configs/ixp2000_defconfig
+++ b/arch/arm/configs/ixp2000_defconfig
@@ -1083,7 +1083,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/ixp23xx_defconfig b/arch/arm/configs/ixp23xx_defconfig
index 27cf022..5fe4bc8 100644
--- a/arch/arm/configs/ixp23xx_defconfig
+++ b/arch/arm/configs/ixp23xx_defconfig
@@ -1378,7 +1378,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/ks8695_defconfig b/arch/arm/configs/ks8695_defconfig
index 8ab21a0..f6debfb 100644
--- a/arch/arm/configs/ks8695_defconfig
+++ b/arch/arm/configs/ks8695_defconfig
@@ -848,7 +848,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 # CONFIG_DEBUG_ERRORS is not set
diff --git a/arch/arm/configs/littleton_defconfig b/arch/arm/configs/littleton_defconfig
index 1db4969..247e3a0 100644
--- a/arch/arm/configs/littleton_defconfig
+++ b/arch/arm/configs/littleton_defconfig
@@ -709,7 +709,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/arm/configs/lpd270_defconfig b/arch/arm/configs/lpd270_defconfig
index a3bf583..26bf97a 100644
--- a/arch/arm/configs/lpd270_defconfig
+++ b/arch/arm/configs/lpd270_defconfig
@@ -1001,7 +1001,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/lpd7a404_defconfig b/arch/arm/configs/lpd7a404_defconfig
index 46a0f7f..e2b9c57 100644
--- a/arch/arm/configs/lpd7a404_defconfig
+++ b/arch/arm/configs/lpd7a404_defconfig
@@ -1097,7 +1097,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index ae4c5e6..b8ddb23 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -863,7 +863,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_USER is not set
 # CONFIG_DEBUG_ERRORS is not set
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 57f32f3..3497cf8 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -869,7 +869,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_DEBUG_USER is not set
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/ns9xxx_defconfig b/arch/arm/configs/ns9xxx_defconfig
index 0e5794c..6b7ed76 100644
--- a/arch/arm/configs/ns9xxx_defconfig
+++ b/arch/arm/configs/ns9xxx_defconfig
@@ -592,7 +592,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/arm/configs/onearm_defconfig b/arch/arm/configs/onearm_defconfig
index 650a248..9bf8342 100644
--- a/arch/arm/configs/onearm_defconfig
+++ b/arch/arm/configs/onearm_defconfig
@@ -1104,7 +1104,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 # CONFIG_DEBUG_ERRORS is not set
diff --git a/arch/arm/configs/picotux200_defconfig b/arch/arm/configs/picotux200_defconfig
index 3c0c4f1..ea608c8 100644
--- a/arch/arm/configs/picotux200_defconfig
+++ b/arch/arm/configs/picotux200_defconfig
@@ -1310,7 +1310,6 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_USER is not set
diff --git a/arch/arm/configs/pnx4008_defconfig b/arch/arm/configs/pnx4008_defconfig
index b5e11aa..69012e6 100644
--- a/arch/arm/configs/pnx4008_defconfig
+++ b/arch/arm/configs/pnx4008_defconfig
@@ -1601,7 +1601,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_DEBUG_USER is not set
 # CONFIG_DEBUG_ERRORS is not set
diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index fc39ba1..db16500 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -963,7 +963,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/rpc_defconfig b/arch/arm/configs/rpc_defconfig
index 5ddecb9..e747783 100644
--- a/arch/arm/configs/rpc_defconfig
+++ b/arch/arm/configs/rpc_defconfig
@@ -987,7 +987,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index f8a1645..10648fd 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -1385,7 +1385,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/versatile_defconfig b/arch/arm/configs/versatile_defconfig
index 48dca69..212e81e 100644
--- a/arch/arm/configs/versatile_defconfig
+++ b/arch/arm/configs/versatile_defconfig
@@ -969,7 +969,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index 0604607..3763d5c 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -1069,7 +1069,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index 2fb2ede..c139b9e 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -1067,7 +1067,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index 45e23e0..058d0fe 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -981,7 +981,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff --git a/arch/ia64/configs/bigsur_defconfig b/arch/ia64/configs/bigsur_defconfig
index 6dd8655..a3723d4 100644
--- a/arch/ia64/configs/bigsur_defconfig
+++ b/arch/ia64/configs/bigsur_defconfig
@@ -1310,7 +1310,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_IA64_GRANULE_16MB is not set
 CONFIG_IA64_GRANULE_64MB=y
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index e86fbd3..42a29ba 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -1344,7 +1344,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_IA64_GRANULE_16MB=y
 # CONFIG_IA64_GRANULE_64MB is not set
diff --git a/arch/ia64/configs/sim_defconfig b/arch/ia64/configs/sim_defconfig
index 546a772..b88153a 100644
--- a/arch/ia64/configs/sim_defconfig
+++ b/arch/ia64/configs/sim_defconfig
@@ -699,7 +699,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_IA64_GRANULE_16MB is not set
 CONFIG_IA64_GRANULE_64MB=y
diff --git a/arch/ia64/configs/sn2_defconfig b/arch/ia64/configs/sn2_defconfig
index 7f6b237..23c70b1 100644
--- a/arch/ia64/configs/sn2_defconfig
+++ b/arch/ia64/configs/sn2_defconfig
@@ -1219,7 +1219,6 @@ CONFIG_SCHED_DEBUG=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/ia64/configs/tiger_defconfig b/arch/ia64/configs/tiger_defconfig
index 797acf9..e325e57 100644
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@ -1223,7 +1223,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_IA64_GRANULE_16MB=y
diff --git a/arch/ia64/configs/zx1_defconfig b/arch/ia64/configs/zx1_defconfig
index 0a06b13..9d50585 100644
--- a/arch/ia64/configs/zx1_defconfig
+++ b/arch/ia64/configs/zx1_defconfig
@@ -1549,7 +1549,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/ia64/defconfig b/arch/ia64/defconfig
index 0210545..385a658 100644
--- a/arch/ia64/defconfig
+++ b/arch/ia64/defconfig
@@ -1389,7 +1389,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_IA64_GRANULE_16MB=y
diff --git a/arch/m32r/configs/opsput_defconfig b/arch/m32r/configs/opsput_defconfig
index 39f5c1a..2ebb6e7 100644
--- a/arch/m32r/configs/opsput_defconfig
+++ b/arch/m32r/configs/opsput_defconfig
@@ -703,7 +703,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
diff --git a/arch/m32r/configs/usrv_defconfig b/arch/m32r/configs/usrv_defconfig
index 62e813e..c7ca03e 100644
--- a/arch/m32r/configs/usrv_defconfig
+++ b/arch/m32r/configs/usrv_defconfig
@@ -707,7 +707,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index abf70d7..bbbd3d8 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -1020,7 +1020,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
diff --git a/arch/mips/configs/mipssim_defconfig b/arch/mips/configs/mipssim_defconfig
index 6db0bda..a4ec3fc 100644
--- a/arch/mips/configs/mipssim_defconfig
+++ b/arch/mips/configs/mipssim_defconfig
@@ -633,7 +633,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/mips/configs/msp71xx_defconfig b/arch/mips/configs/msp71xx_defconfig
index b12b73f..95e6b75 100644
--- a/arch/mips/configs/msp71xx_defconfig
+++ b/arch/mips/configs/msp71xx_defconfig
@@ -1411,7 +1411,6 @@ CONFIG_DEBUG_PREEMPT=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_CROSSCOMPILE=y
diff --git a/arch/mips/configs/pnx8550-jbs_defconfig b/arch/mips/configs/pnx8550-jbs_defconfig
index 518a608..b49c3c8 100644
--- a/arch/mips/configs/pnx8550-jbs_defconfig
+++ b/arch/mips/configs/pnx8550-jbs_defconfig
@@ -1215,7 +1215,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE="console=ttyS1,38400n8 kgdb=ttyS0 root=/dev/nfs ip=bootp"
diff --git a/arch/mips/configs/pnx8550-stb810_defconfig b/arch/mips/configs/pnx8550-stb810_defconfig
index 68351eb..9cf8dd6 100644
--- a/arch/mips/configs/pnx8550-stb810_defconfig
+++ b/arch/mips/configs/pnx8550-stb810_defconfig
@@ -1205,7 +1205,6 @@ CONFIG_DEBUG_SLAB=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE="console=ttyS1,38400n8 kgdb=ttyS0 root=/dev/nfs ip=bootp"
diff --git a/arch/mips/configs/yosemite_defconfig b/arch/mips/configs/yosemite_defconfig
index b6178ff..f699316 100644
--- a/arch/mips/configs/yosemite_defconfig
+++ b/arch/mips/configs/yosemite_defconfig
@@ -824,7 +824,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
diff --git a/arch/parisc/configs/712_defconfig b/arch/parisc/configs/712_defconfig
index 9fc96e7..ee6fb1b 100644
--- a/arch/parisc/configs/712_defconfig
+++ b/arch/parisc/configs/712_defconfig
@@ -910,7 +910,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_RODATA=y
diff --git a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
index ea07121..22e0d16 100644
--- a/arch/parisc/configs/a500_defconfig
+++ b/arch/parisc/configs/a500_defconfig
@@ -1047,7 +1047,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_RWLOCK is not set
diff --git a/arch/parisc/configs/b180_defconfig b/arch/parisc/configs/b180_defconfig
index 1bf22c9..4c0a338 100644
--- a/arch/parisc/configs/b180_defconfig
+++ b/arch/parisc/configs/b180_defconfig
@@ -1034,7 +1034,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_RODATA is not set
diff --git a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
index c6def3c..f50689f 100644
--- a/arch/parisc/configs/c3000_defconfig
+++ b/arch/parisc/configs/c3000_defconfig
@@ -1264,7 +1264,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_DEBUG_RODATA=y
diff --git a/arch/parisc/defconfig b/arch/parisc/defconfig
index 448a757..eb9f8be 100644
--- a/arch/parisc/defconfig
+++ b/arch/parisc/defconfig
@@ -1351,7 +1351,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_RODATA is not set
diff --git a/arch/powerpc/configs/bamboo_defconfig b/arch/powerpc/configs/bamboo_defconfig
index 76d883e..d5562ac 100644
--- a/arch/powerpc/configs/bamboo_defconfig
+++ b/arch/powerpc/configs/bamboo_defconfig
@@ -724,7 +724,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/cell_defconfig b/arch/powerpc/configs/cell_defconfig
index f3bde8c..54e4432 100644
--- a/arch/powerpc/configs/cell_defconfig
+++ b/arch/powerpc/configs/cell_defconfig
@@ -1439,7 +1439,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/celleb_defconfig b/arch/powerpc/configs/celleb_defconfig
index 421e08e..e812edc 100644
--- a/arch/powerpc/configs/celleb_defconfig
+++ b/arch/powerpc/configs/celleb_defconfig
@@ -1230,7 +1230,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index 5989b5d..8b9ae99 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -1395,7 +1395,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/ebony_defconfig b/arch/powerpc/configs/ebony_defconfig
index b84298c..f22fcd2 100644
--- a/arch/powerpc/configs/ebony_defconfig
+++ b/arch/powerpc/configs/ebony_defconfig
@@ -803,7 +803,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
index a1f9820..872851a 100644
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -727,7 +727,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 3673dd2..e1dc92d 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -1599,7 +1599,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/holly_defconfig b/arch/powerpc/configs/holly_defconfig
index a211a79..82f62d1 100644
--- a/arch/powerpc/configs/holly_defconfig
+++ b/arch/powerpc/configs/holly_defconfig
@@ -925,7 +925,6 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/iseries_defconfig b/arch/powerpc/configs/iseries_defconfig
index 4a87745..122e14d 100644
--- a/arch/powerpc/configs/iseries_defconfig
+++ b/arch/powerpc/configs/iseries_defconfig
@@ -1065,7 +1065,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/kilauea_defconfig b/arch/powerpc/configs/kilauea_defconfig
index 28dee12..62dca2e 100644
--- a/arch/powerpc/configs/kilauea_defconfig
+++ b/arch/powerpc/configs/kilauea_defconfig
@@ -692,7 +692,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/linkstation_defconfig b/arch/powerpc/configs/linkstation_defconfig
index 7b42808..397977d 100644
--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -1478,7 +1478,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/lite5200_defconfig b/arch/powerpc/configs/lite5200_defconfig
index 02bb7e5..b1200f2 100644
--- a/arch/powerpc/configs/lite5200_defconfig
+++ b/arch/powerpc/configs/lite5200_defconfig
@@ -823,7 +823,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/maple_defconfig b/arch/powerpc/configs/maple_defconfig
index 8b810d0..ffcf16b 100644
--- a/arch/powerpc/configs/maple_defconfig
+++ b/arch/powerpc/configs/maple_defconfig
@@ -1102,7 +1102,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/mpc8272_ads_defconfig b/arch/powerpc/configs/mpc8272_ads_defconfig
index 5eae305..da51e37 100644
--- a/arch/powerpc/configs/mpc8272_ads_defconfig
+++ b/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -882,7 +882,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/mpc8313_rdb_defconfig b/arch/powerpc/configs/mpc8313_rdb_defconfig
index c9af905..bf1a43a 100644
--- a/arch/powerpc/configs/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/mpc8313_rdb_defconfig
@@ -1277,7 +1277,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/mpc8540_ads_defconfig b/arch/powerpc/configs/mpc8540_ads_defconfig
index 3791e29..fd9d602 100644
--- a/arch/powerpc/configs/mpc8540_ads_defconfig
+++ b/arch/powerpc/configs/mpc8540_ads_defconfig
@@ -708,7 +708,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/mpc8544_ds_defconfig b/arch/powerpc/configs/mpc8544_ds_defconfig
index 18623a8..d51422d 100644
--- a/arch/powerpc/configs/mpc8544_ds_defconfig
+++ b/arch/powerpc/configs/mpc8544_ds_defconfig
@@ -1442,7 +1442,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/mpc8560_ads_defconfig b/arch/powerpc/configs/mpc8560_ads_defconfig
index 51f9693..f0c3f1e 100644
--- a/arch/powerpc/configs/mpc8560_ads_defconfig
+++ b/arch/powerpc/configs/mpc8560_ads_defconfig
@@ -790,7 +790,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/mpc8568mds_defconfig b/arch/powerpc/configs/mpc8568mds_defconfig
index f51b58a..59df3ab 100644
--- a/arch/powerpc/configs/mpc8568mds_defconfig
+++ b/arch/powerpc/configs/mpc8568mds_defconfig
@@ -1002,7 +1002,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/mpc8572_ds_defconfig b/arch/powerpc/configs/mpc8572_ds_defconfig
index b40802d..4f904bd 100644
--- a/arch/powerpc/configs/mpc8572_ds_defconfig
+++ b/arch/powerpc/configs/mpc8572_ds_defconfig
@@ -1442,7 +1442,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/mpc85xx_cds_defconfig b/arch/powerpc/configs/mpc85xx_cds_defconfig
index 2f9ad58..c2f74e0 100644
--- a/arch/powerpc/configs/mpc85xx_cds_defconfig
+++ b/arch/powerpc/configs/mpc85xx_cds_defconfig
@@ -843,7 +843,6 @@ CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/mpc8610_hpcd_defconfig b/arch/powerpc/configs/mpc8610_hpcd_defconfig
index 9614d24..b3ccd39 100644
--- a/arch/powerpc/configs/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/mpc8610_hpcd_defconfig
@@ -997,7 +997,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/mpc8641_hpcn_defconfig b/arch/powerpc/configs/mpc8641_hpcn_defconfig
index ff092fc..507ddec 100644
--- a/arch/powerpc/configs/mpc8641_hpcn_defconfig
+++ b/arch/powerpc/configs/mpc8641_hpcn_defconfig
@@ -1442,7 +1442,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 22f8171..6f4d3d1 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -738,7 +738,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index 292de3d..2f23949 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -1664,7 +1664,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index 5416be4..2134093 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -1885,7 +1885,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 5760b9f..a6cccb3 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -1876,7 +1876,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/pq2fads_defconfig b/arch/powerpc/configs/pq2fads_defconfig
index a3bfbb6..403c5ad 100644
--- a/arch/powerpc/configs/pq2fads_defconfig
+++ b/arch/powerpc/configs/pq2fads_defconfig
@@ -975,7 +975,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SAMPLES is not set
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 0b5469f..a959d4e 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -1066,7 +1066,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_DEBUG_LIST=y
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 92bbf51..d720093 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -1530,7 +1530,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff --git a/arch/powerpc/configs/sequoia_defconfig b/arch/powerpc/configs/sequoia_defconfig
index bc3c086..b681bba 100644
--- a/arch/powerpc/configs/sequoia_defconfig
+++ b/arch/powerpc/configs/sequoia_defconfig
@@ -789,7 +789,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/powerpc/configs/walnut_defconfig b/arch/powerpc/configs/walnut_defconfig
index 7934463..77e594d 100644
--- a/arch/powerpc/configs/walnut_defconfig
+++ b/arch/powerpc/configs/walnut_defconfig
@@ -724,7 +724,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/ppc/configs/ml300_defconfig b/arch/ppc/configs/ml300_defconfig
index d66cacd..065b459 100644
--- a/arch/ppc/configs/ml300_defconfig
+++ b/arch/ppc/configs/ml300_defconfig
@@ -716,7 +716,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KGDB is not set
 # CONFIG_XMON is not set
diff --git a/arch/ppc/configs/ml403_defconfig b/arch/ppc/configs/ml403_defconfig
index 71bcfa7..1cc0a96 100644
--- a/arch/ppc/configs/ml403_defconfig
+++ b/arch/ppc/configs/ml403_defconfig
@@ -717,7 +717,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KGDB is not set
 # CONFIG_XMON is not set
diff --git a/arch/ppc/configs/prep_defconfig b/arch/ppc/configs/prep_defconfig
index b7cee2d..f44edc1 100644
--- a/arch/ppc/configs/prep_defconfig
+++ b/arch/ppc/configs/prep_defconfig
@@ -1658,7 +1658,6 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_FS is not set
 # CONFIG_DEBUG_VM is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_XMON is not set
 # CONFIG_BDI_SWITCH is not set
diff --git a/arch/ppc/configs/taishan_defconfig b/arch/ppc/configs/taishan_defconfig
index 1ca0204..6ba5780 100644
--- a/arch/ppc/configs/taishan_defconfig
+++ b/arch/ppc/configs/taishan_defconfig
@@ -1057,7 +1057,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KGDB is not set
 # CONFIG_XMON is not set
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index ece7b99..1dcfa67 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -722,7 +722,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/sh/configs/cayman_defconfig b/arch/sh/configs/cayman_defconfig
index a05b278..9ff0afc 100644
--- a/arch/sh/configs/cayman_defconfig
+++ b/arch/sh/configs/cayman_defconfig
@@ -1126,7 +1126,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/sh/configs/magicpanelr2_defconfig b/arch/sh/configs/magicpanelr2_defconfig
index f8398a5..bc17069 100644
--- a/arch/sh/configs/magicpanelr2_defconfig
+++ b/arch/sh/configs/magicpanelr2_defconfig
@@ -868,7 +868,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SH_STANDARD_BIOS is not set
diff --git a/arch/sh/configs/r7780mp_defconfig b/arch/sh/configs/r7780mp_defconfig
index 2ad804e..c3cd56d 100644
--- a/arch/sh/configs/r7780mp_defconfig
+++ b/arch/sh/configs/r7780mp_defconfig
@@ -1035,7 +1035,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 # CONFIG_FRAME_POINTER is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/sh/configs/r7785rp_defconfig b/arch/sh/configs/r7785rp_defconfig
index 0dc1ce7..a5e28d8 100644
--- a/arch/sh/configs/r7785rp_defconfig
+++ b/arch/sh/configs/r7785rp_defconfig
@@ -1069,7 +1069,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/sh/configs/sdk7780_defconfig b/arch/sh/configs/sdk7780_defconfig
index bb9bcd6..d6a9388 100644
--- a/arch/sh/configs/sdk7780_defconfig
+++ b/arch/sh/configs/sdk7780_defconfig
@@ -1316,7 +1316,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
index 0d0cda9..1d2b571 100644
--- a/arch/sh/configs/se7206_defconfig
+++ b/arch/sh/configs/se7206_defconfig
@@ -726,7 +726,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SH_STANDARD_BIOS is not set
 CONFIG_EARLY_SCIF_CONSOLE=y
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index 240a1ce..2482766 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -1012,7 +1012,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SH_STANDARD_BIOS is not set
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index a794c08..7e5008c 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -763,7 +763,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_VM=y
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_SH_STANDARD_BIOS=y
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index 0686ed6..a8298f6 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -1624,7 +1624,6 @@ CONFIG_LOG_BUF_SHIFT=16
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_SH_STANDARD_BIOS is not set
diff --git a/arch/sparc/defconfig b/arch/sparc/defconfig
index f7a5091..d6ecbbc 100644
--- a/arch/sparc/defconfig
+++ b/arch/sparc/defconfig
@@ -842,7 +842,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
diff --git a/arch/sparc64/defconfig b/arch/sparc64/defconfig
index f62d9f6..b68268c 100644
--- a/arch/sparc64/defconfig
+++ b/arch/sparc64/defconfig
@@ -1371,7 +1371,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
diff --git a/arch/um/defconfig b/arch/um/defconfig
index f609ede..85eb9de 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -519,7 +519,6 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_VM is not set
 CONFIG_FRAME_POINTER=y
 # CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_GPROF is not set
 # CONFIG_GCOV is not set
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 77562e7..3df340b 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1421,7 +1421,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 9e2b0ef..eef98cb 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1346,7 +1346,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_FORCED_INLINING is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 0ab3a32..974f5b7 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -5,15 +5,6 @@
 /* These definitions are for GCC v4.x.  */
 #include <linux/compiler-gcc.h>
 
-#ifdef CONFIG_FORCED_INLINING
-# undef inline
-# undef __inline__
-# undef __inline
-# define inline			inline		__attribute__((always_inline))
-# define __inline__		__inline__	__attribute__((always_inline))
-# define __inline		__inline	__attribute__((always_inline))
-#endif
-
 #define __used			__attribute__((__used__))
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 89f4035..0f1579d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -449,20 +449,6 @@ config FRAME_POINTER
 	  some architectures or if you use external debuggers.
 	  If you don't debug the kernel, you can say N.
 
-config FORCED_INLINING
-	bool "Force gcc to inline functions marked 'inline'"
-	depends on DEBUG_KERNEL
-	default y
-	help
-	  This option determines if the kernel forces gcc to inline the functions
-	  developers have marked 'inline'. Doing so takes away freedom from gcc to
-	  do what it thinks is best, which is desirable for the gcc 3.x series of
-	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
-	  disabling this option will generate a smaller kernel there. Hopefully
-	  this algorithm is so good that allowing gcc4 to make the decision can
-	  become the default in the future, until then this option is there to
-	  test gcc for this.
-
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
 	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
-- 
1.5.4.rc4.1142.gf5a97



