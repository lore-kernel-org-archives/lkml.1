Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYJQEOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYJQEOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYJQEOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:14:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYJQEOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:14:35 -0400
Date: Thu, 16 Oct 2008 21:14:11 -0700 (PDT)
Message-Id: <20081016.211411.221093995.davem@davemloft.net>
To: mingo@elte.hu
CC: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH]: Kill unused scheduler decl.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I noticed this while making investigations into the tbench
regressions.  Please apply.

sched: Remove hrtick_resched() extern decl.

This function was removed by 31656519e132f6612584815f128c83976a9aaaef
("sched, x86: clean up hrtick implementation").

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c226c7b..6eda6ad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -287,7 +287,6 @@ extern void trap_init(void);
 extern void account_process_tick(struct task_struct *task, int user);
 extern void update_process_times(int user);
 extern void scheduler_tick(void);
-extern void hrtick_resched(void);
 
 extern void sched_show_task(struct task_struct *p);
 
