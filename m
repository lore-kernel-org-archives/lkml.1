Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937017AbZDDA2y (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 3 Apr 2009 20:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbZDDA1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:27:36 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53094 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763963AbZDDA1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:27:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
   niv@us.ibm.com, manfred@colorfullife.com, peterz@infradead.org,
   lethal@linux-sh.org, kernel@wantstofly.org, andi@firstfloor.org,
   kyle@mcmartin.ca, deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org,
   jes@sgi.com, benh@kernel.crashing.org, paulus@samba.org, anton@samba.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] Convert CONFIG_SMP=y ia64 defconfigs to TREE_RCU.
Date: Fri,  3 Apr 2009 17:27:23 -0700
Message-Id: <12388048483751-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12388048487-git-send-email->
References: <12388048487-git-send-email->
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/ia64/configs/generic_defconfig  |    2 +-
 arch/ia64/configs/xen_domu_defconfig |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 7564549..798fd95 100644
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
diff --git a/arch/ia64/configs/xen_domu_defconfig b/arch/ia64/configs/xen_domu_defconfig
index 0bb0714..539ac38 100644
--- a/arch/ia64/configs/xen_domu_defconfig
+++ b/arch/ia64/configs/xen_domu_defconfig
@@ -104,8 +104,8 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
-CONFIG_CLASSIC_RCU=y
-# CONFIG_TREE_RCU is not set
+CONFIG_TREE_RCU=y
+# CONFIG_CLASSIC_RCU is not set
 # CONFIG_PREEMPT_RCU is not set
 # CONFIG_TREE_RCU_TRACE is not set
 # CONFIG_PREEMPT_RCU_TRACE is not set
-- 
1.5.2.5

