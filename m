Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYJRBvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYJRBvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 21:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYJRBvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 21:51:09 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:56689 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYJRBvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 21:51:08 -0400
Date: Sat, 18 Oct 2008 09:51:12 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: Dotan Barak <dotanba@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/workqueue.c mm/sparse.c: fix some linux coding
	style typos
Message-ID: <20081018015112.GA6861@ubuntu>
References: <200810180516.40060.dotanba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810180516.40060.dotanba@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 05:16:39AM +0200, Dotan Barak wrote:
>workqueues: fix some linux coding style typos:
>
>* spaces were replaced with tabs
>* "foo* bar" was replaced with "foo *bar"
>
>Signed-off-by: Dotan Barak <dotanba@gmail.com>
>
>---
>
>diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>index 714afad..f9de8b5 100644
>--- a/kernel/workqueue.c
>+++ b/kernel/workqueue.c
>@@ -300,7 +300,7 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)

The same problem is in mm/sparse.c .

* spaces were replaced with tabs
* "foo* bar" was replaced with "foo *bar"

Signed-off-by: Dotan Barak <dotanba@gmail.com>
Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 kernel/workqueue.c |    6 +++---
 mm/sparse.c        |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

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
diff --git a/mm/sparse.c b/mm/sparse.c
index 39db301..47cb5c3 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -114,7 +114,7 @@ static inline int sparse_index_init(unsigned long section_nr, int nid)
  * to also work for the flat array case because
  * NR_SECTION_ROOTS==NR_MEM_SECTIONS.
  */
-int __section_nr(struct mem_section* ms)
+int __section_nr(struct mem_section *ms)
 {
 	unsigned long root_nr;
 	struct mem_section* root;
-- 
1.5.2.5

-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
