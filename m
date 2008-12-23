Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbYLWAP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbYLWAP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYLWAMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:33 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59381 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbYLWAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH -tip] Switch mn10300 defconfig from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Date: Mon, 22 Dec 2008 16:12:24 -0800
Message-Id: <12299911472516-git-send-email-paulmck@linux.vnet.ibm.com>
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
 arch/mn10300/configs/asb2303_defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 3aa8906..4b3695f 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -84,7 +84,7 @@ CONFIG_RT_MUTEXES=y
 CONFIG_BASE_SMALL=0
 # CONFIG_MODULES is not set
 # CONFIG_BLOCK is not set
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_PREEMPT_RCU is not set
 
 #
-- 
1.5.2.5

