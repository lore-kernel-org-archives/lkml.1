Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZHORJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZHORJF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZHORJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:09:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:33783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZHORJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:09:01 -0400
Date: Sat, 15 Aug 2009 17:08:07 GMT
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       mingo@elte.hu
In-Reply-To: <1250355231169-git-send-email->
References: <1250355231169-git-send-email->
Subject: [tip:core/rcu] rcu: Fix typo in rcu_irq_exit() comment header
Message-ID: <tip-684ca5cc9a772532bc893cdc994bd89bf0773719@git.kernel.org>
Git-Commit-ID: 684ca5cc9a772532bc893cdc994bd89bf0773719
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 17:08:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  684ca5cc9a772532bc893cdc994bd89bf0773719
Gitweb:     http://git.kernel.org/tip/684ca5cc9a772532bc893cdc994bd89bf0773719
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sat, 15 Aug 2009 09:53:51 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 19:02:09 +0200

rcu: Fix typo in rcu_irq_exit() comment header

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: josht@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: hugh.dickins@tiscali.co.uk
Cc: benh@kernel.crashing.org
LKML-Reference: <1250355231169-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcupreempt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 2748b89..510898a 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -548,7 +548,7 @@ void rcu_irq_enter(void)
  * rcu_irq_exit - Called from exiting Hard irq context.
  *
  * If the CPU was idle with dynamic ticks active, update the
- * rcu_dyntick_sched.dynticks to put let the RCU handling be
+ * rcu_dyntick_sched.dynticks to let the RCU handling be
  * aware that the CPU is going back to idle with no ticks.
  */
 void rcu_irq_exit(void)
