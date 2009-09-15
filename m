Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZIOHSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZIOHSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbZIOHSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:18:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:49497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbZIOHSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:18:10 -0400
Date: Tue, 15 Sep 2009 07:17:31 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
       paulmck@linux.vnet.ibm.com, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12528585112362-git-send-email->
References: <12528585112362-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Kconfig help needs to say that TREE_PREEMPT_RCU scales down
Message-ID: <tip-da054e04e4d7c8d340ddc8dc45d4f7cad7672b96@git.kernel.org>
Git-Commit-ID: da054e04e4d7c8d340ddc8dc45d4f7cad7672b96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 07:17:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da054e04e4d7c8d340ddc8dc45d4f7cad7672b96
Gitweb:     http://git.kernel.org/tip/da054e04e4d7c8d340ddc8dc45d4f7cad7672b96
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 13 Sep 2009 09:15:08 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 08:43:58 +0200

rcu: Kconfig help needs to say that TREE_PREEMPT_RCU scales down

To quote Valdis:

    This leaves somebody who has a laptop wondering which
    choice is best for a system with only one or two cores that
    has CONFIG_PREEMPT defined. One choice says it scales down
    nicely, the other explicitly has a 'depends on PREEMPT'
    attached to it...

So add "scales down nicely" to TREE_PREEMPT_RCU to match that of
TREE_RCU.

Suggested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <12528585112362-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 init/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 8e8b76d..4c2c936 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -331,7 +331,8 @@ config TREE_PREEMPT_RCU
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
 	  thousands of CPUs, but for which real-time response
-	  is also required.
+	  is also required.  It also scales down nicely to
+	  smaller systems.
 
 endchoice
 
