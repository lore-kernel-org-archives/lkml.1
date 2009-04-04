Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbZDDA1q (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 3 Apr 2009 20:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762927AbZDDA1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:27:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52465 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762382AbZDDA1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:27:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
   niv@us.ibm.com, manfred@colorfullife.com, peterz@infradead.org,
   lethal@linux-sh.org, kernel@wantstofly.org, andi@firstfloor.org,
   kyle@mcmartin.ca, deller@gmx.de, davem@davemloft.net, ralf@linux-mips.org,
   jes@sgi.com, benh@kernel.crashing.org, paulus@samba.org, anton@samba.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] Make TREE_RCU be default (was CLASSIC_RCU).
Date: Fri,  3 Apr 2009 17:27:21 -0700
Message-Id: <12388048487-git-send-email->
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that there have been no TREE_RCU bugs reported for some months,
it is time to make TREE_RCU be the default RCU implementation.  The rest
of this series updates defconfig files that: (1) have CONFIG_SMP=y and
(2) explicitly mention CONFIG_CLASSIC_RCU.

Given that I don't have access to most of the relevant hardware, much
of this is untested.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 236a793..ef9d030 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -302,7 +302,7 @@ menu "RCU Subsystem"
 
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU
 
 config CLASSIC_RCU
 	bool "Classic RCU"
-- 
1.5.2.5

