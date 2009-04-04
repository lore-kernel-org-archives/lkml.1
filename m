Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937131AbZDDA3V (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 3 Apr 2009 20:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbZDDA1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:27:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52484 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764720AbZDDA1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:27:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
   niv@us.ibm.com, manfred@colorfullife.com, peterz@infradead.org,
   lethal@linux-sh.org, kernel@wantstofly.org, andi@firstfloor.org,
   kyle@mcmartin.ca, deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org,
   jes@sgi.com, benh@kernel.crashing.org, paulus@samba.org, anton@samba.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] Convert CONFIG_SMP=y sparc defconfigs to TREE_RCU.
Date: Fri,  3 Apr 2009 17:27:26 -0700
Message-Id: <1238804849405-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12388048487-git-send-email->
References: <12388048487-git-send-email->
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/sparc/configs/sparc64_defconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index ade4994..7d3e192 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -127,8 +127,8 @@ CONFIG_DEFAULT_AS=y
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

