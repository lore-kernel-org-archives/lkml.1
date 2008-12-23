Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYLWAOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYLWAOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYLWAM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:29 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54815 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842AbYLWAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH -tip] Switch m68knommu from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Date: Mon, 22 Dec 2008 16:12:22 -0800
Message-Id: <12299911471660-git-send-email-paulmck@linux.vnet.ibm.com>
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
 arch/m68knommu/configs/m5208evb_defconfig |    2 +-
 arch/m68knommu/configs/m5249evb_defconfig |    2 +-
 arch/m68knommu/configs/m5275evb_defconfig |    2 +-
 arch/m68knommu/configs/m5307c3_defconfig  |    2 +-
 arch/m68knommu/configs/m5407c3_defconfig  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68knommu/configs/m5208evb_defconfig b/arch/m68knommu/configs/m5208evb_defconfig
index 6fae33a..eed8981 100644
--- a/arch/m68knommu/configs/m5208evb_defconfig
+++ b/arch/m68knommu/configs/m5208evb_defconfig
@@ -93,7 +93,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Processor type and features
diff --git a/arch/m68knommu/configs/m5249evb_defconfig b/arch/m68knommu/configs/m5249evb_defconfig
index cc64583..71956bd 100644
--- a/arch/m68knommu/configs/m5249evb_defconfig
+++ b/arch/m68knommu/configs/m5249evb_defconfig
@@ -92,7 +92,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Processor type and features
diff --git a/arch/m68knommu/configs/m5275evb_defconfig b/arch/m68knommu/configs/m5275evb_defconfig
index 0d1256f..801ec9d 100644
--- a/arch/m68knommu/configs/m5275evb_defconfig
+++ b/arch/m68knommu/configs/m5275evb_defconfig
@@ -95,7 +95,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Processor type and features
diff --git a/arch/m68knommu/configs/m5307c3_defconfig b/arch/m68knommu/configs/m5307c3_defconfig
index fe2acdf..84cffcf 100644
--- a/arch/m68knommu/configs/m5307c3_defconfig
+++ b/arch/m68knommu/configs/m5307c3_defconfig
@@ -95,7 +95,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Processor type and features
diff --git a/arch/m68knommu/configs/m5407c3_defconfig b/arch/m68knommu/configs/m5407c3_defconfig
index 1118936..0a83c3b 100644
--- a/arch/m68knommu/configs/m5407c3_defconfig
+++ b/arch/m68knommu/configs/m5407c3_defconfig
@@ -96,7 +96,7 @@ CONFIG_IOSCHED_NOOP=y
 # CONFIG_DEFAULT_CFQ is not set
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 
 #
 # Processor type and features
-- 
1.5.2.5

