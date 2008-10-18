Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYJQU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYJQU57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYJQU5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:57:53 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:46648 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYJQU5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=s3KkUzF9ks9RqJb4h8m2m/9xbMDhOvWc6aSx7GVqecpAGon0+CkU0qNrtB1hoVp9Sw
         HsyE7UW8blEIU4Z9A2v5ttuQwJvkGEKuH2IRR+BxrrKJGPq2BDzVNOh+PH4zLJMhmVYE
         /NkYkPhJqMwo6UnrkN21L5x5s2GwMW9Q0yF4M=
From: Dotan Barak <dotanba@gmail.com>
To: akpm@linux-foundation.org
Subject: [PATCH] workqueues: fix some linux coding style typos
Date: Sat, 18 Oct 2008 05:16:39 +0200
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810180516.40060.dotanba@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueues: fix some linux coding style typos:

* spaces were replaced with tabs
* "foo* bar" was replaced with "foo *bar"

Signed-off-by: Dotan Barak <dotanba@gmail.com>

---

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 714afad..f9de8b5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -300,7 +300,7 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
 					"%s/0x%08x/%d\n",
 					current->comm, preempt_count(),
-				       	task_pid_nr(current));
+					task_pid_nr(current));
 			printk(KERN_ERR "    last function: ");
 			print_symbol("%s\n", (unsigned long)f);
 			debug_show_held_locks(current);
@@ -551,7 +551,7 @@ static void wait_on_work(struct work_struct *work)
 }
 
 static int __cancel_work_timer(struct work_struct *work,
-				struct timer_list* timer)
+				struct timer_list *timer)
 {
 	int ret;
 
@@ -908,7 +908,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 
 	for_each_cpu_mask_nr(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
- 	cpu_maps_update_done();
+	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
