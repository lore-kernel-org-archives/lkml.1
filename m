Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937235AbZDDAaH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 3 Apr 2009 20:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933723AbZDDA1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:27:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35551 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765067AbZDDA1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:27:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
   niv@us.ibm.com, manfred@colorfullife.com, peterz@infradead.org,
   lethal@linux-sh.org, kernel@wantstofly.org, andi@firstfloor.org,
   kyle@mcmartin.ca, deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org,
   jes@sgi.com, benh@kernel.crashing.org, paulus@samba.org, anton@samba.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] Convert CONFIG_SMP=y arm defconfigs to TREE_RCU.
Date: Fri,  3 Apr 2009 17:27:25 -0700
Message-Id: <12388048491297-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12388048487-git-send-email->
References: <12388048487-git-send-email->
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/arm/configs/realview-smp_defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index 21db4b3..0fada5c 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -119,7 +119,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
-CONFIG_CLASSIC_RCU=y
+CONFIG_TREE_RCU=y
 # CONFIG_FREEZER is not set
 
 #
-- 
1.5.2.5

