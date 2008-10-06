Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYJFPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYJFPKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYJFPKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:10:12 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:45720
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbYJFPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:10:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT PATCH v3 1/2] RT: Remove comment that is no longer true
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com,
       Gilles.Carry@bull.net
Date: Mon, 06 Oct 2008 11:14:37 -0400
Message-ID: <20081006151437.8452.80167.stgit@dev.haskins.net>
In-Reply-To: <20081006151228.8452.69938.stgit@dev.haskins.net>
References: <20081006151228.8452.69938.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed the condition noted in the comment with the "pushable_tasks"
logic, but forgot to remove this comment.  Lets clean it up.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 57a0c0d..59ead84 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1125,16 +1125,6 @@ out:
 	return 1;
 }
 
-/*
- * TODO: Currently we just use the second highest prio task on
- *       the queue, and stop when it can't migrate (or there's
- *       no more RT tasks).  There may be a case where a lower
- *       priority RT task has a different affinity than the
- *       higher RT task. In this case the lower RT task could
- *       possibly be able to migrate where as the higher priority
- *       RT task could not.  We currently ignore this issue.
- *       Enhancements are welcome!
- */
 static void push_rt_tasks(struct rq *rq)
 {
 	/* push_rt_task will return true if it moved an RT */

