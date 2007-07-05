Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbXGEX0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbXGEX0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762973AbXGEXXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:23:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52152 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762873AbXGEXXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:23:10 -0400
Date: Fri, 6 Jul 2007 01:23:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] kernel/sched.c: make 2 functions static
Message-ID: <20070705232338.GF3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- load_balance_start()
- load_balance_next()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc6-mm1/kernel/sched.c.old	2007-07-05 16:39:42.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/sched.c	2007-07-05 16:43:38.000000000 +0200
@@ -2011,7 +2011,7 @@
  * classes, starting with the highest-prio one:
  */
 
-struct task_struct * load_balance_start(struct rq *rq)
+static struct task_struct * load_balance_start(struct rq *rq)
 {
 	struct sched_class *class = sched_class_highest;
 	struct task_struct *p;
@@ -2028,7 +2028,7 @@
 	return NULL;
 }
 
-struct task_struct * load_balance_next(struct rq *rq)
+static struct task_struct * load_balance_next(struct rq *rq)
 {
 	struct sched_class *class = rq->load_balance_class;
 	struct task_struct *p;

