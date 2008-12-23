Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbYLWAOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbYLWAOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbYLWAM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:12:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42934 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbYLWAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH -tip] Switch ia64 defconfig from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Date: Mon, 22 Dec 2008 16:12:20 -0800
Message-Id: <12299911474050-git-send-email-paulmck@linux.vnet.ibm.com>
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
 arch/ia64/configs/generic_defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 27eb676..124f14a 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -110,7 +110,7 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
-- 
1.5.2.5

