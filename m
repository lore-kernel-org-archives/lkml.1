Return-Path: <linux-kernel-owner+w=401wt.eu-S1031603AbXEKTxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031603AbXEKTxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966169AbXEKTog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:36 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46658 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966139AbXEKToe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:34 -0400
Message-ID: <4644C79D.40803@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:44:29 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: kernel/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in kernel/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 kernel/acct.c             |    2 +-
 kernel/compat.c           |    2 +-
 kernel/cpuset.c           |    2 +-
 kernel/delayacct.c        |    2 +-
 kernel/fork.c             |    2 +-
 kernel/futex.c            |    2 +-
 kernel/futex_compat.c     |    2 +-
 kernel/irq/chip.c         |    4 ++--
 kernel/irq/handle.c       |    6 +++---
 kernel/irq/manage.c       |    2 +-
 kernel/irq/migration.c    |    2 +-
 kernel/irq/resend.c       |    2 +-
 kernel/kallsyms.c         |    2 +-
 kernel/kexec.c            |   10 +++++-----
 kernel/kfifo.c            |    2 +-
 kernel/kmod.c             |    2 +-
 kernel/kprobes.c          |    2 +-
 kernel/kthread.c          |    2 +-
 kernel/latency.c          |    2 +-
 kernel/module.c           |    2 +-
 kernel/posix-timers.c     |    4 ++--
 kernel/power/snapshot.c   |    2 +-
 kernel/sched.c            |   20 ++++++++++----------
 kernel/softirq.c          |    2 +-
 kernel/taskstats.c        |    2 +-
 kernel/time.c             |    2 +-
 kernel/time/clocksource.c |    2 +-
 kernel/time/jiffies.c     |    2 +-
 28 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 70d0d88..0b0acb2 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -25,7 +25,7 @@
  *  XTerms and EMACS are manifestations of pure evil. 21/10/98, AV.
  *
  *  Fixed a nasty interaction with with sys_umount(). If the accointing
- *  was suspeneded we failed to stop it on umount(). Messy.
+ *  was suspended we failed to stop it on umount(). Messy.
  *  Another one: remount to readonly didn't stop accounting.
  *	Question: what should we do if we have CAP_SYS_ADMIN but not
  *  CAP_SYS_PACCT? Current code does the following: umount returns -EBUSY
diff --git a/kernel/compat.c b/kernel/compat.c
index cebb4c2..c5e0c1a 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1,7 +1,7 @@
 /*
  *  linux/kernel/compat.c
  *
- *  Kernel compatibililty routines for e.g. 32 bit syscall support
+ *  Kernel compatibility routines for e.g. 32 bit syscall support
  *  on 64 bit kernels.
  *
  *  Copyright (C) 2002-2003 Stephen Rothwell, IBM Corporation
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f57854b..35c8c6f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -855,7 +855,7 @@ static int update_cpumask(struct cpuset *cs, char *buf)
  *
  *    Migrate memory region from one set of nodes to another.
  *
- *    Temporarilly set tasks mems_allowed to target nodes of migration,
+ *    Temporarily set tasks mems_allowed to target nodes of migration,
  *    so that the migration code can allocate pages on these nodes.
  *
  *    Call holding manage_mutex, so our current->cpuset won't change
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index c0148ae..1fc6316 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -54,7 +54,7 @@ static inline void delayacct_start(struct timespec *start)
 
 /*
  * Finish delay accounting for a statistic using
- * its timestamps (@start, @end), accumalator (@total) and @count
+ * its timestamps (@start, @end), accumulator (@total) and @count
  */
 
 static void delayacct_end(struct timespec *start, struct timespec *end,
diff --git a/kernel/fork.c b/kernel/fork.c
index 5dd3979..f9f5ee4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -712,7 +712,7 @@ static struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 			/*
 			 * The fd may be claimed in the fd bitmap but not yet
 			 * instantiated in the files array if a sibling thread
-			 * is partway through open().  So make sure that this
+			 * is part way through open().  So make sure that this
 			 * fd is available to the new process.
 			 */
 			FD_CLR(open_files - i, new_fdt->open_fds);
diff --git a/kernel/futex.c b/kernel/futex.c
index b7ce15c..9c1ba51 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1506,7 +1506,7 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 			hrtimer_cancel(&t.timer);
 
-			/* Flag if a timeout occured */
+			/* Flag if a timeout occurred */
 			rem = (t.task == NULL);
 		}
 	}
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 338a9b4..5625c24 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -1,7 +1,7 @@
 /*
  * linux/kernel/futex_compat.c
  *
- * Futex compatibililty routines.
+ * Futex compatibility routines.
  *
  * Copyright 2006, Red Hat, Inc., Ingo Molnar
  */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 615ce97..32b4a55 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -431,8 +431,8 @@ out:
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq
  *
- *	Interrupt occures on the falling and/or rising edge of a hardware
- *	signal. The occurence is latched into the irq controller hardware
+ *	Interrupt occurs on the falling and/or rising edge of a hardware
+ *	signal. The occurrence is latched into the irq controller hardware
  *	and must be acked in order to be reenabled. After the ack another
  *	interrupt can happen on the same source even before the first one
  *	is handled by the assosiacted event handler. If this happens it
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e391cbb..0c684df 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -23,7 +23,7 @@
  * @irq:       the interrupt number
  * @desc:      description of the interrupt
  *
- * Handles spurious and unhandled IRQ's. It also prints a debugmessage.
+ * Handles spurious and unhandled IRQs. It also prints a debug message.
  */
 void fastcall
 handle_bad_irq(unsigned int irq, struct irq_desc *desc)
@@ -62,7 +62,7 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?
- * Each architecture has to answer this themself.
+ * Each architecture has to answer this itself.
  */
 static void ack_bad(unsigned int irq)
 {
@@ -156,7 +156,7 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
  * __do_IRQ - original all in one highlevel IRQ handler
  * @irq:	the interrupt number
  *
- * __do_IRQ handles all normal device IRQ's (the special
+ * __do_IRQ handles all normal device IRQs (the special
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  *
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 203a518..d3a665e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -240,7 +240,7 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 void compat_irq_chip_set_default_handler(struct irq_desc *desc)
 {
 	/*
-	 * If the architecture still has not overriden
+	 * If the architecture still has not overridden
 	 * the flow handler then zap the default. This
 	 * should catch incorrect flow-type setting.
 	 */
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 77b7acc..20d5fb6 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -45,7 +45,7 @@ void move_masked_irq(int irq)
 	 * do the disable, re-program, enable sequence.
 	 * This is *not* particularly important for level triggered
 	 * but in a edge trigger case, we might be setting rte
-	 * when an active trigger is comming in. This could
+	 * when an active trigger is coming in. This could
 	 * cause some ioapics to mal-function.
 	 * Being paranoid i guess!
 	 *
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 5bfeaed..e331ec7 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -26,7 +26,7 @@
 static DECLARE_BITMAP(irqs_resend, NR_IRQS);
 
 /*
- * Run software resends of IRQ's
+ * Run software resends of IRQs
  */
 static void resend_irqs(unsigned long arg)
 {
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index f1bda23..9325657 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -119,7 +119,7 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
 }
 
 /* get symbol type information. This is encoded as a single char at the
- * begining of the symbol name */
+ * beginning of the symbol name */
 static char kallsyms_get_symbol_type(unsigned int off)
 {
 	/* get just the first code, look it up in the token table, and return the
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 25db14b..71d2bed 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -144,7 +144,7 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	 * just verifies it is an address we can use.
 	 *
 	 * Since the kernel does everything in page size chunks ensure
-	 * the destination addreses are page aligned.  Too many
+	 * the destination addresses are page aligned.  Too many
 	 * special cases crop of when we don't do this.  The most
 	 * insidious is getting overlapping destination addresses
 	 * simply because addresses are changed to page size
@@ -163,7 +163,7 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	}
 
 	/* Verify our destination addresses do not overlap.
-	 * If we alloed overlapping destination addresses
+	 * If we allowed overlapping destination addresses
 	 * through very weird things can happen with no
 	 * easy explanation as one segment stops on another.
 	 */
@@ -429,7 +429,7 @@ static struct page *kimage_alloc_normal_control_pages(struct kimage *image,
 	/* Deal with the destination pages I have inadvertently allocated.
 	 *
 	 * Ideally I would convert multi-page allocations into single
-	 * page allocations, and add everyting to image->dest_pages.
+	 * page allocations, and add everything to image->dest_pages.
 	 *
 	 * For now it is simpler to just free the pages.
 	 */
@@ -447,7 +447,7 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 	 * not conflict with either the destination addresses
 	 * or memory the kernel is already using.
 	 *
-	 * Control pages are also the only pags we must allocate
+	 * Control pages are also the only pages we must allocate
 	 * when loading a crash kernel.  All of the other pages
 	 * are specified by the segments and we just memcpy
 	 * into them directly.
@@ -719,7 +719,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 			break;
 
 		/*
-		 * I know that the page is someones destination page.
+		 * I know that the page is someone's destination page.
 		 * See if there is already a source page for this
 		 * destination page.  And if so swap the source pages.
 		 */
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index cee4191..65e5eaa 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -71,7 +71,7 @@ struct kfifo *kfifo_alloc(unsigned int size, gfp_t gfp_mask, spinlock_t *lock)
 
 	/*
 	 * round up to the next power of 2, since our 'let the indices
-	 * wrap' tachnique works only in this case.
+	 * wrap' technique works only in this case.
 	 */
 	if (size & (size - 1)) {
 		BUG_ON(size > 0x80000000);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 4d32eb0..c3810ba 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -49,7 +49,7 @@ char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 /**
  * request_module - try to load a kernel module
  * @fmt:     printf style format string for the name of the module
- * @varargs: arguements as specified in the format string
+ * @varargs: arguments as specified in the format string
  *
  * Load a module using the user mode module loader. The function returns
  * zero on success or a negative errno code on failure. Note that a
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9e47d8c..bf2faec 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -539,7 +539,7 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 	if (probed_mod) {
 		struct module *calling_mod = module_text_address(called_from);
 		/*
-		 * We must allow modules to probe themself and in this case
+		 * We must allow modules to probe themselves and in this case
 		 * avoid incrementing the module refcount, so as to allow
 		 * unloading of self probing modules.
 		 */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index df8a8e8..cc2d5fd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -40,7 +40,7 @@ struct kthread_stop_info
 	struct completion done;
 };
 
-/* Thread stopping is done by setthing this var: lock serializes
+/* Thread stopping is done by setting this var: lock serializes
  * multiple kthread_stop calls. */
 static DEFINE_MUTEX(kthread_stop_lock);
 static struct kthread_stop_info kthread_stop_info;
diff --git a/kernel/latency.c b/kernel/latency.c
index e63fcac..132b858 100644
--- a/kernel/latency.c
+++ b/kernel/latency.c
@@ -18,7 +18,7 @@
  * constraint of, say, 150 usec.
  *
  * Multiple drivers can each announce their maximum accepted latency,
- * to keep these appart, a string based identifier is used.
+ * to keep these apart, a string based identifier is used.
  *
  *
  * (C) Copyright 2006 Intel Corporation
diff --git a/kernel/module.c b/kernel/module.c
index 9bd93de..b5b59ba 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2075,7 +2075,7 @@ static const char *get_ksymbol(struct module *mod,
 	else 
 		nextval = (unsigned long)mod->module_core+mod->core_text_size;
 
-	/* Scan for closest preceeding symbol, and next symbol. (ELF
+	/* Scan for closest preceding symbol, and next symbol. (ELF
            starts real symbols at 1). */
 	for (i = 1; i < mod->num_symtab; i++) {
 		if (mod->symtab[i].st_shndx == SHN_UNDEF)
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 588c99d..9c2f8d7 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -272,7 +272,7 @@ static void schedule_next_timer(struct k_itimer *timr)
  * restarted (i.e. we have flagged this in the sys_private entry of the
  * info block).
  *
- * To protect aginst the timer going away while the interrupt is queued,
+ * To protect against the timer going away while the interrupt is queued,
  * we require that the it_requeue_pending flag be set.
  */
 void do_schedule_next_timer(struct siginfo *info)
@@ -461,7 +461,7 @@ sys_timer_create(const clockid_t which_clock,
 		goto retry;
 	else if (error) {
 		/*
-		 * Wierd looking, but we return EAGAIN if the IDR is
+		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
 		 */
 		error = -EAGAIN;
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index a3b7854..4cdea28 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1019,7 +1019,7 @@ static unsigned int nr_meta_pages;
 /**
  *	swsusp_free - free pages allocated for the suspend.
  *
- *	Suspend pages are alocated before the atomic copy is made, so we
+ *	Suspend pages are allocated before the atomic copy is made, so we
  *	need to release them after the resume.
  */
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 799d23b..83ccea8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1414,7 +1414,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	 * Siblings must be also busy(in most cases) as they didn't already
 	 * pickup the extra load from this cpu and hence we need not check
 	 * sibling runqueue info. This will avoid the checks and cache miss
-	 * penalities associated with that.
+	 * penalties associated with that.
 	 */
 	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
 		return cpu;
@@ -4363,7 +4363,7 @@ recheck:
 	 */
 	spin_lock_irqsave(&p->pi_lock, flags);
 	/*
-	 * To be able to change p->policy safely, the apropriate
+	 * To be able to change p->policy safely, the appropriate
 	 * runqueue lock must be held.
 	 */
 	rq = __task_rq_lock(p);
@@ -4589,9 +4589,9 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 }
 
 /*
- * Represents all cpu's present in the system
+ * Represents all CPUs present in the system
  * In systems capable of hotplug, this map could dynamically grow
- * as new cpu's are detected in the system via any platform specific
+ * as new CPUs are detected in the system via any platform specific
  * method, such as ACPI for e.g.
  */
 
@@ -4973,7 +4973,7 @@ void show_state_filter(unsigned long state_filter)
 	do_each_thread(g, p) {
 		/*
 		 * reset the NMI-timeout, listing all files on a slow
-		 * console might take alot of time:
+		 * console might take a lot of time:
 		 */
 		touch_nmi_watchdog();
 		if (!state_filter || (p->state & state_filter))
@@ -5039,8 +5039,8 @@ cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
 /*
  * This is how migration works:
  *
- * 1) we queue a struct migration_req structure in the source CPU's
- *    runqueue and wake up that CPU's migration thread.
+ * 1) we queue a struct migration_req structure in the source CPUs
+ *    runqueue and wake up that CPUs migration thread.
  * 2) we down() the locked semaphore => thread blocks.
  * 3) migration thread wakes up (implicitly it forces the migrated
  *    thread off the CPU)
@@ -5255,7 +5255,7 @@ restart:
  * While a dead CPU has no uninterruptible tasks queued at this point,
  * it might still have a nonzero ->nr_uninterruptible counter, because
  * for performance reasons the counter is not stricly tracking tasks to
- * their home CPUs. So we just add the counter to another CPU's counter,
+ * their home CPUs. So we just add the counter to another CPUs counter,
  * to keep the global sum constant after CPU-down:
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
@@ -5443,7 +5443,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 		/* No need to migrate the tasks: it was best-effort if
 		 * they didn't take sched_hotcpu_mutex.  Just wake up
-		 * the requestors. */
+		 * the requesters. */
 		spin_lock_irq(&rq->lock);
 		while (!list_empty(&rq->migration_queue)) {
 			struct migration_req *req;
@@ -7132,7 +7132,7 @@ struct task_struct *curr_task(int cpu)
  * Description: This function must only be used when non-maskable interrupts
  * are serviced on a separate stack.  It allows the architecture to switch the
  * notion of the current task on a cpu in a non-blocking manner.  This function
- * must be called with all CPU's synchronized, and interrupts disabled, the
+ * must be called with all CPUs synchronized, and interrupts disabled, the
  * and caller must save the original value of the current task (see
  * curr_task() above) and restore that value before reenabling interrupts and
  * re-starting the system.
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0b9886a..50a22ed 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -611,7 +611,7 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(ksoftirqd, hotcpu))
 			break;
-		/* Unbind so it can run.  Fall thru. */
+		/* Unbind so it can run.  Fall through. */
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
 			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 906cae7..756342f 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -268,7 +268,7 @@ static void fill_tgid_exit(struct task_struct *tsk)
 
 	/*
 	 * Each accounting subsystem calls its functions here to
-	 * accumalate its per-task stats for tsk, into the per-tgid structure
+	 * accumulate its per-task stats for tsk, into the per-tgid structure
 	 *
 	 *	per-task-foo(tsk->signal->stats, tsk);
 	 */
diff --git a/kernel/time.c b/kernel/time.c
index f04791f..cc52b4c 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -573,7 +573,7 @@ EXPORT_SYMBOL(usecs_to_jiffies);
 /*
  * The TICK_NSEC - 1 rounds up the value to the next resolution.  Note
  * that a remainder subtract here would not do the right thing as the
- * resolution values don't fall on second boundries.  I.e. the line:
+ * resolution values don't fall on second boundaries.  I.e. the line:
  * nsec -= nsec % TICK_NSEC; is NOT a correct resolution rounding.
  *
  * Rather, we just shift the bits off the right.
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 3db5c3c..c3085c4 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -367,7 +367,7 @@ sysfs_show_current_clocksources(struct sys_device *dev, char *buf)
  * @count:	length of buffer
  *
  * Takes input from sysfs interface for manually overriding the default
- * clocksource selction.
+ * clocksource selection.
  */
 static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  const char *buf, size_t count)
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 4c256fd..70d958a 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -30,7 +30,7 @@
  * the timer interrupt frequency HZ and it suffers
  * inaccuracies caused by missed or lost timer
  * interrupts and the inability for the timer
- * interrupt hardware to accuratly tick at the
+ * interrupt hardware to accurately tick at the
  * requested HZ value. It is also not reccomended
  * for "tick-less" systems.
  */
-- 
1.5.0.1

-- 
Simon Arlott
