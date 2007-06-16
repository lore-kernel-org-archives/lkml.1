Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbXFPK0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbXFPK0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXFPKYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:16 -0400
Received: from www.osadl.org ([213.239.205.134]:37168 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753323AbXFPKYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:10 -0400
Message-Id: <20070616101636.715085242@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch-mm 05/25] timer.c cleanup recently introduced whitespace damage
Content-Disposition: inline; filename=timer-fix-whitespace.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6.22-rc4-mm/kernel/timer.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/timer.c	2007-06-16 12:10:22.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/timer.c	2007-06-16 12:10:23.000000000 +0200
@@ -103,14 +103,14 @@ static inline tvec_base_t *tbase_get_bas
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
 	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
-	                               TBASE_DEFERRABLE_FLAG));
+				       TBASE_DEFERRABLE_FLAG));
 }
 
 static inline void
 timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
 {
 	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
-	                              tbase_get_deferrable(timer->base));
+				      tbase_get_deferrable(timer->base));
 }
 
 /**
@@ -445,10 +445,10 @@ EXPORT_SYMBOL(__mod_timer);
 void add_timer_on(struct timer_list *timer, int cpu)
 {
 	tvec_base_t *base = per_cpu(tvec_bases, cpu);
-  	unsigned long flags;
+	unsigned long flags;
 
 	timer_stats_timer_set_start_info(timer);
-  	BUG_ON(timer_pending(timer) || !timer->function);
+	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	internal_add_timer(base, timer);
@@ -627,7 +627,7 @@ static inline void __run_timers(tvec_bas
 	while (time_after_eq(jiffies, base->timer_jiffies)) {
 		struct list_head work_list;
 		struct list_head *head = &work_list;
- 		int index = base->timer_jiffies & TVR_MASK;
+		int index = base->timer_jiffies & TVR_MASK;
 
 		/*
 		 * Cascade timers:
@@ -644,8 +644,8 @@ static inline void __run_timers(tvec_bas
 			unsigned long data;
 
 			timer = list_first_entry(head, struct timer_list,entry);
- 			fn = timer->function;
- 			data = timer->data;
+			fn = timer->function;
+			data = timer->data;
 
 			timer_stats_account_timer(timer);
 
@@ -689,8 +689,8 @@ static unsigned long __next_timer_interr
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
- 			if (tbase_get_deferrable(nte->base))
- 				continue;
+			if (tbase_get_deferrable(nte->base))
+				continue;
 
 			found = 1;
 			expires = nte->expires;
@@ -834,7 +834,7 @@ void update_process_times(int user_tick)
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
 	scheduler_tick();
- 	run_posix_cpu_timers(p);
+	run_posix_cpu_timers(p);
 }
 
 /*
@@ -909,7 +909,7 @@ static inline void update_times(unsigned
 	update_wall_time();
 	calc_load(ticks);
 }
-  
+
 /*
  * The 64-bit jiffies value is not atomic - you MUST NOT read it
  * without sampling the sequence number in xtime_lock.
@@ -1105,7 +1105,7 @@ asmlinkage long sys_gettid(void)
 /**
  * do_sysinfo - fill in sysinfo struct
  * @info: pointer to buffer to fill
- */ 
+ */
 int do_sysinfo(struct sysinfo *info)
 {
 	unsigned long mem_total, sav_total;

-- 

