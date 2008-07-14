Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYGNNzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYGNNzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYGNNy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:54:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39324 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYGNNyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:54:51 -0400
Date: Mon, 14 Jul 2008 15:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler changes for v2.6.27
Message-ID: <20080714135433.GA9609@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched/for-linus

Thanks,

	Ingo

------------------>
Ankita Garg (1):
      sched: fix accounting in task delay accounting & migration

Arjan van de Ven (1):
      sched: print module list in the "scheduling while atomic" warning

David Rientjes (1):
      sched: prevent bound kthreads from changing cpus_allowed

Dhaval Giani (2):
      sched: add comments for ifdefs in sched.c
      sched: make sched_{rt,fair}.c ifdefs more readable

Dmitry Adamushko (2):
      sched: check for SD_SERIALIZE atomically in rebalance_domains()
      sched: rework of "prioritize non-migratable tasks over migratable ones"

Gautham R Shenoy (2):
      sched: update the sched-domains debug documentation
      sched: print the sd->level in sched_domain_debug code

Gregory Haskins (7):
      sched: prioritize non-migratable tasks over migratable ones
      sched: use a 2-d bitmap for searching lowest-pri CPU
      sched: fix SCHED_OTHER balance iterator to include all tasks
      sched: fix cpupri hotplug support
      sched: fix cpupri priocount
      sched: terminate newidle balancing once at least one task has moved over
      sched: add avg-overlap support to RT tasks

Hiroshi Shimamoto (1):
      sched: fix typo in Documentation/scheduler/sched-rt-group.txt

Ingo Molnar (5):
      namespacecheck: more sched.c fixes
      sched: fix cpuprio build bug
      sched: export cpu_clock
      sched: sched_clock_cpu() based cpu_clock(), lockdep fix
      sched: build fix

Max Krasnyansky (2):
      sched: CPU hotplug events must not destroy scheduler domains created by the cpusets
      sched: Move cpu masks from kernel/sched.c into kernel/cpu.c

Mike Galbraith (2):
      sched: make !hrtick faster
      sched: trivial sched_features cleanup

Paul Mundt (1):
      sched: kill off dead cfs_rq_set_shares()

Peter Zijlstra (34):
      sched: fix hotplug cpus on ia64
      sched: debug: add some rt debug output
      sched: rt: fix SMP bandwidth balancing for throttled groups
      sched: rt: move some code around
      sched: rt: fix the bandwidth contraint computations
      sched: rt: dont stop the period timer when there are tasks wanting to run
      sched: clean up some unused variables
      sched: revert the revert of: weight calculations
      sched: fix calc_delta_asym()
      sched: fix calc_delta_asym, #2
      sched: revert revert of: fair-group: SMP-nice for group scheduling
      sched: sched_clock_cpu() based cpu_clock()
      sched: fix wakeup granularity and buddy granularity
      sched: add full schedstats to /proc/sched_debug
      sched: fix sched_domain aggregation
      sched: update aggregate when holding the RQs
      sched: dont micro manage share losses
      sched: no need to aggregate task_weight
      sched: simplify the group load balancer
      sched: fix newidle smp group balancing
      sched: fix sched_balance_self() smp group balancing
      sched: persistent average load per task
      sched: hierarchical load vs affine wakeups
      sched: hierarchical load vs find_busiest_group
      sched: fix load scaling in group balancing
      sched: fix task_h_load()
      sched: remove prio preference from balance decisions
      sched: optimize effective_load()
      sched: disable source/target_load bias
      sched: fix shares boost logic
      sched: update shares on wakeup
      sched: correct wakeup weight calculations
      sched: incremental effective_load()
      sched: bias effective_load() error towards failing wake_affine().

Rabin Vincent (1):
      sched: fix defined-but-unused warning

Richard Kennedy (1):
      sched: reorder task_struct to reduce padding on 64bit builds

Srivatsa Vaddagiri (2):
      sched: kill task_group balancing
      sched: fix mult overflow

Steven Rostedt (7):
      sched_clock: record from last tick
      sched_clock: widen the max and min time
      sched_clock: stop maximum check on NO HZ
      sched_clock: fix calculation of other CPU
      sched_clock: only update deltas with local reads.
      sched_clock: record TSC after gtod
      sched_clock: and multiplier for TSC to gtod drift

Thomas Gleixner (3):
      namespacecheck: fixes in kernel/sched.c
      sched: fix the cpuprio count really
      sched: move weighted_cpuload into #ifdef CONFIG_SMP section

Vegard Nossum (1):
      sched: fix warning


 Documentation/scheduler/sched-domains.txt  |    7 +-
 Documentation/scheduler/sched-rt-group.txt |    4 +-
 include/linux/sched.h                      |   59 ++--
 kernel/Makefile                            |    5 +-
 kernel/cpu.c                               |   24 +
 kernel/cpuset.c                            |   14 +-
 kernel/kthread.c                           |    1 +
 kernel/sched.c                             |  723 +++++++++++++++++++---------
 kernel/sched_clock.c                       |  137 +++++-
 kernel/sched_cpupri.c                      |  174 +++++++
 kernel/sched_cpupri.h                      |   36 ++
 kernel/sched_debug.c                       |   64 +++-
 kernel/sched_fair.c                        |  413 +++++++++++-----
 kernel/sched_features.h                    |    7 +-
 kernel/sched_rt.c                          |  405 ++++++++++------
 kernel/sched_stats.h                       |   42 ++-
 kernel/sysctl.c                            |    8 +
 kernel/time/tick-sched.c                   |    2 +
 18 files changed, 1555 insertions(+), 570 deletions(-)
 create mode 100644 kernel/sched_cpupri.c
 create mode 100644 kernel/sched_cpupri.h

diff --git a/Documentation/scheduler/sched-domains.txt b/Documentation/scheduler/sched-domains.txt
index a9e990a..373ceac 100644
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -61,10 +61,7 @@ builder by #define'ing ARCH_HASH_SCHED_DOMAIN, and exporting your
 arch_init_sched_domains function. This function will attach domains to all
 CPUs using cpu_attach_domain.
 
-Implementors should change the line
-#undef SCHED_DOMAIN_DEBUG
-to
-#define SCHED_DOMAIN_DEBUG
-in kernel/sched.c as this enables an error checking parse of the sched domains
+The sched-domains debugging infrastructure can be enabled by enabling
+CONFIG_SCHED_DEBUG. This enables an error checking parse of the sched domains
 which should catch most possible errors (described above). It also prints out
 the domain structure in a visual format.
diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 14f901f..3ef339f 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -51,9 +51,9 @@ needs only about 3% CPU time to do so, it can do with a 0.03 * 0.005s =
 0.00015s. So this group can be scheduled with a period of 0.005s and a run time
 of 0.00015s.
 
-The remaining CPU time will be used for user input and other tass. Because
+The remaining CPU time will be used for user input and other tasks. Because
 realtime tasks have explicitly allocated the CPU time they need to perform
-their tasks, buffer underruns in the graphocs or audio can be eliminated.
+their tasks, buffer underruns in the graphics or audio can be eliminated.
 
 NOTE: the above example is not fully implemented as of yet (2.6.25). We still
 lack an EDF scheduler to make non-uniform periods usable.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..f6cd60f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -134,7 +134,6 @@ extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
-extern unsigned long weighted_cpuload(const int cpu);
 
 struct seq_file;
 struct cfs_rq;
@@ -784,6 +783,8 @@ struct sched_domain {
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
+	u64 last_update;
+
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
 	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
@@ -823,23 +824,6 @@ extern int arch_reinit_sched_domains(void);
 
 #endif	/* CONFIG_SMP */
 
-/*
- * A runqueue laden with a single nice 0 task scores a weighted_cpuload of
- * SCHED_LOAD_SCALE. This function returns 1 if any cpu is laden with a
- * task of nice 0 or enough lower priority tasks to bring up the
- * weighted_cpuload
- */
-static inline int above_background_load(void)
-{
-	unsigned long cpu;
-
-	for_each_online_cpu(cpu) {
-		if (weighted_cpuload(cpu) >= SCHED_LOAD_SCALE)
-			return 1;
-	}
-	return 0;
-}
-
 struct io_context;			/* See blkdev.h */
 #define NGROUPS_SMALL		32
 #define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
@@ -921,8 +905,8 @@ struct sched_class {
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const cpumask_t *newmask);
 
-	void (*join_domain)(struct rq *rq);
-	void (*leave_domain)(struct rq *rq);
+	void (*rq_online)(struct rq *rq);
+	void (*rq_offline)(struct rq *rq);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
@@ -1039,6 +1023,7 @@ struct task_struct {
 #endif
 
 	int prio, static_prio, normal_prio;
+	unsigned int rt_priority;
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
@@ -1122,7 +1107,6 @@ struct task_struct {
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
-	unsigned int rt_priority;
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
 	cputime_t prev_utime, prev_stime;
@@ -1141,12 +1125,12 @@ struct task_struct {
 	gid_t gid,egid,sgid,fsgid;
 	struct group_info *group_info;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted, cap_bset;
-	unsigned securebits;
 	struct user_struct *user;
+	unsigned securebits;
 #ifdef CONFIG_KEYS
+	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
 	struct key *request_key_auth;	/* assumed request_key authority */
 	struct key *thread_keyring;	/* keyring private to this thread */
-	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
 #endif
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
@@ -1233,8 +1217,8 @@ struct task_struct {
 # define MAX_LOCK_DEPTH 48UL
 	u64 curr_chain_key;
 	int lockdep_depth;
-	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	unsigned int lockdep_recursion;
+	struct held_lock held_locks[MAX_LOCK_DEPTH];
 #endif
 
 /* journalling filesystem info */
@@ -1262,10 +1246,6 @@ struct task_struct {
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
 	cputime_t acct_stimexpd;/* stime since last update */
 #endif
-#ifdef CONFIG_NUMA
-  	struct mempolicy *mempolicy;
-	short il_next;
-#endif
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;
 	int cpuset_mems_generation;
@@ -1285,6 +1265,10 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
+#ifdef CONFIG_NUMA
+	struct mempolicy *mempolicy;
+	short il_next;
+#endif
 	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
 
@@ -1504,6 +1488,7 @@ static inline void put_task_struct(struct task_struct *t)
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
+#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
@@ -1573,13 +1558,28 @@ static inline void sched_clock_idle_sleep_event(void)
 static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
 }
-#else
+
+#ifdef CONFIG_NO_HZ
+static inline void sched_clock_tick_stop(int cpu)
+{
+}
+
+static inline void sched_clock_tick_start(int cpu)
+{
+}
+#endif
+
+#else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 extern void sched_clock_init(void);
 extern u64 sched_clock_cpu(int cpu);
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
+#ifdef CONFIG_NO_HZ
+extern void sched_clock_tick_stop(int cpu);
+extern void sched_clock_tick_start(int cpu);
 #endif
+#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -1622,6 +1622,7 @@ extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_shares_ratelimit;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
diff --git a/kernel/Makefile b/kernel/Makefile
index 1c9938a..6c55301 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
-	    exit.o itimer.o time.o softirq.o resource.o \
+	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
@@ -27,7 +27,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_SMP) += cpu.o spinlock.o
+obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
@@ -69,6 +69,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
+obj-$(CONFIG_SMP) += sched_cpupri.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/cpu.c b/kernel/cpu.c
index c77bc3a..b11f06d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,28 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 
+/*
+ * Represents all cpu's present in the system
+ * In systems capable of hotplug, this map could dynamically grow
+ * as new cpu's are detected in the system via any platform specific
+ * method, such as ACPI for e.g.
+ */
+cpumask_t cpu_present_map __read_mostly;
+EXPORT_SYMBOL(cpu_present_map);
+
+#ifndef CONFIG_SMP
+
+/*
+ * Represents all cpu's that are currently online.
+ */
+cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_online_map);
+
+cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_possible_map);
+
+#else /* CONFIG_SMP */
+
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
@@ -403,3 +425,5 @@ out:
 	cpu_maps_update_done();
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
+
+#endif /* CONFIG_SMP */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 798b3ab..459d601 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1194,6 +1194,15 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
+	if (tsk->flags & PF_THREAD_BOUND) {
+		cpumask_t mask;
+
+		mutex_lock(&callback_mutex);
+		mask = cs->cpus_allowed;
+		mutex_unlock(&callback_mutex);
+		if (!cpus_equal(tsk->cpus_allowed, mask))
+			return -EINVAL;
+	}
 
 	return security_task_setscheduler(tsk, 0, NULL);
 }
@@ -1207,11 +1216,14 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
+	int err;
 
 	mutex_lock(&callback_mutex);
 	guarantee_online_cpus(cs, &cpus);
-	set_cpus_allowed_ptr(tsk, &cpus);
+	err = set_cpus_allowed_ptr(tsk, &cpus);
 	mutex_unlock(&callback_mutex);
+	if (err)
+		return;
 
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index bd1b9ea..97747cd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -180,6 +180,7 @@ void kthread_bind(struct task_struct *k, unsigned int cpu)
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
 	k->rt.nr_cpus_allowed = 1;
+	k->flags |= PF_THREAD_BOUND;
 }
 EXPORT_SYMBOL(kthread_bind);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 4e2f603..d16c8d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -74,6 +74,8 @@
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 
+#include "sched_cpupri.h"
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -289,15 +291,15 @@ struct task_group root_task_group;
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
-#endif
-#else
+#endif /* CONFIG_RT_GROUP_SCHED */
+#else /* !CONFIG_FAIR_GROUP_SCHED */
 #define root_task_group init_task_group
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 /* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
@@ -307,9 +309,9 @@ static DEFINE_SPINLOCK(task_group_lock);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
-#else
+#else /* !CONFIG_USER_SCHED */
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
-#endif
+#endif /* CONFIG_USER_SCHED */
 
 /*
  * A weight of 0 or 1 can cause arithmetics problems.
@@ -363,6 +365,10 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #else
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	return NULL;
+}
 
 #endif	/* CONFIG_GROUP_SCHED */
 
@@ -373,6 +379,7 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+	u64 pair_start;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
@@ -401,6 +408,31 @@ struct cfs_rq {
 	 */
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
+
+#ifdef CONFIG_SMP
+	/*
+	 * the part of load.weight contributed by tasks
+	 */
+	unsigned long task_weight;
+
+	/*
+	 *   h_load = weight * f(tg)
+	 *
+	 * Where f(tg) is the recursive weight fraction assigned to
+	 * this group.
+	 */
+	unsigned long h_load;
+
+	/*
+	 * this cpu's part of tg->shares
+	 */
+	unsigned long shares;
+
+	/*
+	 * load.weight at the time we set shares
+	 */
+	unsigned long rq_weight;
+#endif
 #endif
 };
 
@@ -452,6 +484,9 @@ struct root_domain {
 	 */
 	cpumask_t rto_mask;
 	atomic_t rto_count;
+#ifdef CONFIG_SMP
+	struct cpupri cpupri;
+#endif
 };
 
 /*
@@ -526,6 +561,9 @@ struct rq {
 	int push_cpu;
 	/* cpu of this runqueue: */
 	int cpu;
+	int online;
+
+	unsigned long avg_load_per_task;
 
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
@@ -749,6 +787,12 @@ late_initcall(sched_init_debug);
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
+ * ratelimit for updating the group shares.
+ * default: 0.5ms
+ */
+const_debug unsigned int sysctl_sched_shares_ratelimit = 500000;
+
+/*
  * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
@@ -775,82 +819,6 @@ static inline u64 global_rt_runtime(void)
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-unsigned long long time_sync_thresh = 100000;
-
-static DEFINE_PER_CPU(unsigned long long, time_offset);
-static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
-
-/*
- * Global lock which we take every now and then to synchronize
- * the CPUs time. This method is not warp-safe, but it's good
- * enough to synchronize slowly diverging time sources and thus
- * it's good enough for tracing:
- */
-static DEFINE_SPINLOCK(time_sync_lock);
-static unsigned long long prev_global_time;
-
-static unsigned long long __sync_cpu_clock(unsigned long long time, int cpu)
-{
-	/*
-	 * We want this inlined, to not get tracer function calls
-	 * in this critical section:
-	 */
-	spin_acquire(&time_sync_lock.dep_map, 0, 0, _THIS_IP_);
-	__raw_spin_lock(&time_sync_lock.raw_lock);
-
-	if (time < prev_global_time) {
-		per_cpu(time_offset, cpu) += prev_global_time - time;
-		time = prev_global_time;
-	} else {
-		prev_global_time = time;
-	}
-
-	__raw_spin_unlock(&time_sync_lock.raw_lock);
-	spin_release(&time_sync_lock.dep_map, 1, _THIS_IP_);
-
-	return time;
-}
-
-static unsigned long long __cpu_clock(int cpu)
-{
-	unsigned long long now;
-
-	/*
-	 * Only call sched_clock() if the scheduler has already been
-	 * initialized (some code might call cpu_clock() very early):
-	 */
-	if (unlikely(!scheduler_running))
-		return 0;
-
-	now = sched_clock_cpu(cpu);
-
-	return now;
-}
-
-/*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
- */
-unsigned long long cpu_clock(int cpu)
-{
-	unsigned long long prev_cpu_time, time, delta_time;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
-	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
-	delta_time = time-prev_cpu_time;
-
-	if (unlikely(delta_time > time_sync_thresh)) {
-		time = __sync_cpu_clock(time, cpu);
-		per_cpu(prev_cpu_time, cpu) = time;
-	}
-	local_irq_restore(flags);
-
-	return time;
-}
-EXPORT_SYMBOL_GPL(cpu_clock);
-
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
@@ -1313,15 +1281,15 @@ void wake_up_idle_cpu(int cpu)
 	if (!tsk_is_polling(rq->idle))
 		smp_send_reschedule(cpu);
 }
-#endif
+#endif /* CONFIG_NO_HZ */
 
-#else
+#else /* !CONFIG_SMP */
 static void __resched_task(struct task_struct *p, int tif_bit)
 {
 	assert_spin_locked(&task_rq(p)->lock);
 	set_tsk_thread_flag(p, tif_bit);
 }
-#endif
+#endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
@@ -1336,6 +1304,9 @@ static void __resched_task(struct task_struct *p, int tif_bit)
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
+/*
+ * delta *= weight / lw
+ */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1363,12 +1334,6 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
-static inline unsigned long
-calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
-{
-	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
-}
-
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
@@ -1479,17 +1444,211 @@ static inline void dec_cpu_load(struct rq *rq, unsigned long load)
 #ifdef CONFIG_SMP
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
-static unsigned long cpu_avg_load_per_task(int cpu);
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-#else /* CONFIG_SMP */
+
+static unsigned long cpu_avg_load_per_task(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	if (rq->nr_running)
+		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+
+	return rq->avg_load_per_task;
+}
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
+
+typedef void (*tg_visitor)(struct task_group *, int, struct sched_domain *);
+
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ */
+static void
+walk_tg_tree(tg_visitor down, tg_visitor up, int cpu, struct sched_domain *sd)
+{
+	struct task_group *parent, *child;
+
+	rcu_read_lock();
+	parent = &root_task_group;
+down:
+	(*down)(parent, cpu, sd);
+	list_for_each_entry_rcu(child, &parent->children, siblings) {
+		parent = child;
+		goto down;
+
+up:
+		continue;
+	}
+	(*up)(parent, cpu, sd);
+
+	child = parent;
+	parent = parent->parent;
+	if (parent)
+		goto up;
+	rcu_read_unlock();
+}
+
+static void __set_se_shares(struct sched_entity *se, unsigned long shares);
+
+/*
+ * Calculate and set the cpu's group shares.
+ */
+static void
+__update_group_shares_cpu(struct task_group *tg, int cpu,
+			  unsigned long sd_shares, unsigned long sd_rq_weight)
 {
+	int boost = 0;
+	unsigned long shares;
+	unsigned long rq_weight;
+
+	if (!tg->se[cpu])
+		return;
+
+	rq_weight = tg->cfs_rq[cpu]->load.weight;
+
+	/*
+	 * If there are currently no tasks on the cpu pretend there is one of
+	 * average load so that when a new task gets to run here it will not
+	 * get delayed by group starvation.
+	 */
+	if (!rq_weight) {
+		boost = 1;
+		rq_weight = NICE_0_LOAD;
+	}
+
+	if (unlikely(rq_weight > sd_rq_weight))
+		rq_weight = sd_rq_weight;
+
+	/*
+	 *           \Sum shares * rq_weight
+	 * shares =  -----------------------
+	 *               \Sum rq_weight
+	 *
+	 */
+	shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
+
+	/*
+	 * record the actual number of shares, not the boosted amount.
+	 */
+	tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
+	tg->cfs_rq[cpu]->rq_weight = rq_weight;
+
+	if (shares < MIN_SHARES)
+		shares = MIN_SHARES;
+	else if (shares > MAX_SHARES)
+		shares = MAX_SHARES;
+
+	__set_se_shares(tg->se[cpu], shares);
 }
+
+/*
+ * Re-compute the task group their per cpu shares over the given domain.
+ * This needs to be done in a bottom-up fashion because the rq weight of a
+ * parent group depends on the shares of its child groups.
+ */
+static void
+tg_shares_up(struct task_group *tg, int cpu, struct sched_domain *sd)
+{
+	unsigned long rq_weight = 0;
+	unsigned long shares = 0;
+	int i;
+
+	for_each_cpu_mask(i, sd->span) {
+		rq_weight += tg->cfs_rq[i]->load.weight;
+		shares += tg->cfs_rq[i]->shares;
+	}
+
+	if ((!shares && rq_weight) || shares > tg->shares)
+		shares = tg->shares;
+
+	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
+		shares = tg->shares;
+
+	if (!rq_weight)
+		rq_weight = cpus_weight(sd->span) * NICE_0_LOAD;
+
+	for_each_cpu_mask(i, sd->span) {
+		struct rq *rq = cpu_rq(i);
+		unsigned long flags;
+
+		spin_lock_irqsave(&rq->lock, flags);
+		__update_group_shares_cpu(tg, i, shares, rq_weight);
+		spin_unlock_irqrestore(&rq->lock, flags);
+	}
+}
+
+/*
+ * Compute the cpu's hierarchical load factor for each task group.
+ * This needs to be done in a top-down fashion because the load of a child
+ * group is a fraction of its parents load.
+ */
+static void
+tg_load_down(struct task_group *tg, int cpu, struct sched_domain *sd)
+{
+	unsigned long load;
+
+	if (!tg->parent) {
+		load = cpu_rq(cpu)->load.weight;
+	} else {
+		load = tg->parent->cfs_rq[cpu]->h_load;
+		load *= tg->cfs_rq[cpu]->shares;
+		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+	}
+
+	tg->cfs_rq[cpu]->h_load = load;
+}
+
+static void
+tg_nop(struct task_group *tg, int cpu, struct sched_domain *sd)
+{
+}
+
+static void update_shares(struct sched_domain *sd)
+{
+	u64 now = cpu_clock(raw_smp_processor_id());
+	s64 elapsed = now - sd->last_update;
+
+	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
+		sd->last_update = now;
+		walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
+	}
+}
+
+static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
+{
+	spin_unlock(&rq->lock);
+	update_shares(sd);
+	spin_lock(&rq->lock);
+}
+
+static void update_h_load(int cpu)
+{
+	walk_tg_tree(tg_load_down, tg_nop, cpu, NULL);
+}
+
+#else
+
+static inline void update_shares(struct sched_domain *sd)
+{
+}
+
+static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
+{
+}
+
 #endif
 
-#endif /* CONFIG_SMP */
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
+{
+#ifdef CONFIG_SMP
+	cfs_rq->shares = shares;
+#endif
+}
+#endif
 
 #include "sched_stats.h"
 #include "sched_idletask.c"
@@ -1500,27 +1659,17 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 #endif
 
 #define sched_class_highest (&rt_sched_class)
+#define for_each_class(class) \
+   for (class = sched_class_highest; class; class = class->next)
 
-static inline void inc_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_add(&rq->load, p->se.load.weight);
-}
-
-static inline void dec_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_sub(&rq->load, p->se.load.weight);
-}
-
-static void inc_nr_running(struct task_struct *p, struct rq *rq)
+static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
-	inc_load(rq, p);
 }
 
-static void dec_nr_running(struct task_struct *p, struct rq *rq)
+static void dec_nr_running(struct rq *rq)
 {
 	rq->nr_running--;
-	dec_load(rq, p);
 }
 
 static void set_load_weight(struct task_struct *p)
@@ -1544,6 +1693,12 @@ static void set_load_weight(struct task_struct *p)
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
+static void update_avg(u64 *avg, u64 sample)
+{
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+}
+
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	sched_info_queued(p);
@@ -1553,6 +1708,13 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	if (sleep && p->se.last_wakeup) {
+		update_avg(&p->se.avg_overlap,
+			   p->se.sum_exec_runtime - p->se.last_wakeup);
+		p->se.last_wakeup = 0;
+	}
+
+	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
 }
@@ -1612,7 +1774,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(p, rq);
+	inc_nr_running(rq);
 }
 
 /*
@@ -1624,7 +1786,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(p, rq);
+	dec_nr_running(rq);
 }
 
 /**
@@ -1636,12 +1798,6 @@ inline int task_curr(const struct task_struct *p)
 	return cpu_curr(task_cpu(p)) == p;
 }
 
-/* Used instead of source_load when we know the type == 0 */
-unsigned long weighted_cpuload(const int cpu)
-{
-	return cpu_rq(cpu)->load.weight;
-}
-
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
@@ -1670,6 +1826,12 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 
 #ifdef CONFIG_SMP
 
+/* Used instead of source_load when we know the type == 0 */
+static unsigned long weighted_cpuload(const int cpu)
+{
+	return cpu_rq(cpu)->load.weight;
+}
+
 /*
  * Is this task likely cache-hot:
  */
@@ -1880,7 +2042,7 @@ static unsigned long source_load(int cpu, int type)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0)
+	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
 
 	return min(rq->cpu_load[type-1], total);
@@ -1895,25 +2057,13 @@ static unsigned long target_load(int cpu, int type)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0)
+	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
 
 	return max(rq->cpu_load[type-1], total);
 }
 
 /*
- * Return the average load per task on the cpu's run queue
- */
-static unsigned long cpu_avg_load_per_task(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-	unsigned long n = rq->nr_running;
-
-	return n ? total / n : SCHED_LOAD_SCALE;
-}
-
-/*
  * find_idlest_group finds and returns the least busy CPU group within the
  * domain.
  */
@@ -2019,6 +2169,9 @@ static int sched_balance_self(int cpu, int flag)
 			sd = tmp;
 	}
 
+	if (sd)
+		update_shares(sd);
+
 	while (sd) {
 		cpumask_t span, tmpmask;
 		struct sched_group *group;
@@ -2085,6 +2238,22 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
+#ifdef CONFIG_SMP
+	if (sched_feat(LB_WAKEUP_UPDATE)) {
+		struct sched_domain *sd;
+
+		this_cpu = raw_smp_processor_id();
+		cpu = task_cpu(p);
+
+		for_each_domain(this_cpu, sd) {
+			if (cpu_isset(cpu, sd->span)) {
+				update_shares(sd);
+				break;
+			}
+		}
+	}
+#endif
+
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
 	old_state = p->state;
@@ -2131,7 +2300,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 			}
 		}
 	}
-#endif
+#endif /* CONFIG_SCHEDSTATS */
 
 out_activate:
 #endif /* CONFIG_SMP */
@@ -2157,6 +2326,8 @@ out_running:
 		p->sched_class->task_wake_up(rq, p);
 #endif
 out:
+	current->se.last_wakeup = current->se.sum_exec_runtime;
+
 	task_rq_unlock(rq, &flags);
 
 	return success;
@@ -2277,7 +2448,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(p, rq);
+		inc_nr_running(rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -2331,7 +2502,7 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 		notifier->ops->sched_out(notifier, next);
 }
 
-#else
+#else /* !CONFIG_PREEMPT_NOTIFIERS */
 
 static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
 {
@@ -2343,7 +2514,7 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 {
 }
 
-#endif
+#endif /* CONFIG_PREEMPT_NOTIFIERS */
 
 /**
  * prepare_task_switch - prepare to switch tasks
@@ -2785,7 +2956,7 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      enum cpu_idle_type idle, int *all_pinned,
 	      int *this_best_prio, struct rq_iterator *iterator)
 {
-	int loops = 0, pulled = 0, pinned = 0, skip_for_load;
+	int loops = 0, pulled = 0, pinned = 0;
 	struct task_struct *p;
 	long rem_load_move = max_load_move;
 
@@ -2801,14 +2972,8 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 next:
 	if (!p || loops++ > sysctl_sched_nr_migrate)
 		goto out;
-	/*
-	 * To help distribute high priority tasks across CPUs we don't
-	 * skip a task if it will be the highest priority task (i.e. smallest
-	 * prio value) on its new queue regardless of its load weight
-	 */
-	skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
-							 SCHED_LOAD_SCALE_FUZZ;
-	if ((skip_for_load && p->prio >= *this_best_prio) ||
+
+	if ((p->se.load.weight >> 1) > rem_load_move ||
 	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
 		p = iterator->next(iterator->arg);
 		goto next;
@@ -2863,6 +3028,10 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 				max_load_move - total_load_moved,
 				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
+
+		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
+			break;
+
 	} while (class && max_load_move > total_load_moved);
 
 	return total_load_moved > 0;
@@ -2939,6 +3108,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	max_load = this_load = total_load = total_pwr = 0;
 	busiest_load_per_task = busiest_nr_running = 0;
 	this_load_per_task = this_nr_running = 0;
+
 	if (idle == CPU_NOT_IDLE)
 		load_idx = sd->busy_idx;
 	else if (idle == CPU_NEWLY_IDLE)
@@ -2953,6 +3123,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		int __group_imb = 0;
 		unsigned int balance_cpu = -1, first_idle_cpu = 0;
 		unsigned long sum_nr_running, sum_weighted_load;
+		unsigned long sum_avg_load_per_task;
+		unsigned long avg_load_per_task;
 
 		local_group = cpu_isset(this_cpu, group->cpumask);
 
@@ -2961,6 +3133,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
+		sum_avg_load_per_task = avg_load_per_task = 0;
+
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
@@ -2994,6 +3168,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 			avg_load += load;
 			sum_nr_running += rq->nr_running;
 			sum_weighted_load += weighted_cpuload(i);
+
+			sum_avg_load_per_task += cpu_avg_load_per_task(i);
 		}
 
 		/*
@@ -3015,7 +3191,20 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		avg_load = sg_div_cpu_power(group,
 				avg_load * SCHED_LOAD_SCALE);
 
-		if ((max_cpu_load - min_cpu_load) > SCHED_LOAD_SCALE)
+
+		/*
+		 * Consider the group unbalanced when the imbalance is larger
+		 * than the average weight of two tasks.
+		 *
+		 * APZ: with cgroup the avg task weight can vary wildly and
+		 *      might not be a suitable number - should we keep a
+		 *      normalized nr_running number somewhere that negates
+		 *      the hierarchy?
+		 */
+		avg_load_per_task = sg_div_cpu_power(group,
+				sum_avg_load_per_task * SCHED_LOAD_SCALE);
+
+		if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 			__group_imb = 1;
 
 		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
@@ -3156,9 +3345,9 @@ small_imbalance:
 			if (busiest_load_per_task > this_load_per_task)
 				imbn = 1;
 		} else
-			this_load_per_task = SCHED_LOAD_SCALE;
+			this_load_per_task = cpu_avg_load_per_task(this_cpu);
 
-		if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
+		if (max_load - this_load + 2*busiest_load_per_task >=
 					busiest_load_per_task * imbn) {
 			*imbalance = busiest_load_per_task;
 			return busiest;
@@ -3284,6 +3473,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
+	update_shares(sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
 				   cpus, balance);
 
@@ -3386,8 +3576,9 @@ redo:
 
 	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	return ld_moved;
+		ld_moved = -1;
+
+	goto out;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
@@ -3402,8 +3593,13 @@ out_one_pinned:
 
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	return 0;
+		ld_moved = -1;
+	else
+		ld_moved = 0;
+out:
+	if (ld_moved)
+		update_shares(sd);
+	return ld_moved;
 }
 
 /*
@@ -3438,6 +3634,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
 
 	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
 redo:
+	update_shares_locked(this_rq, sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
 				   &sd_idle, cpus, NULL);
 	if (!group) {
@@ -3481,6 +3678,7 @@ redo:
 	} else
 		sd->nr_balance_failed = 0;
 
+	update_shares_locked(this_rq, sd);
 	return ld_moved;
 
 out_balanced:
@@ -3672,6 +3870,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
+	int need_serialize;
 	cpumask_t tmp;
 
 	for_each_domain(cpu, sd) {
@@ -3689,8 +3888,9 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (interval > HZ*NR_CPUS/10)
 			interval = HZ*NR_CPUS/10;
 
+		need_serialize = sd->flags & SD_SERIALIZE;
 
-		if (sd->flags & SD_SERIALIZE) {
+		if (need_serialize) {
 			if (!spin_trylock(&balancing))
 				goto out;
 		}
@@ -3706,7 +3906,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 			}
 			sd->last_balance = jiffies;
 		}
-		if (sd->flags & SD_SERIALIZE)
+		if (need_serialize)
 			spin_unlock(&balancing);
 out:
 		if (time_after(next_balance, sd->last_balance + interval)) {
@@ -4070,6 +4270,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		prev->comm, prev->pid, preempt_count());
 
 	debug_show_held_locks(prev);
+	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
 
@@ -4143,7 +4344,7 @@ asmlinkage void __sched schedule(void)
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
-	int cpu;
+	int cpu, hrtick = sched_feat(HRTICK);
 
 need_resched:
 	preempt_disable();
@@ -4158,7 +4359,8 @@ need_resched_nonpreemptible:
 
 	schedule_debug(prev);
 
-	hrtick_clear(rq);
+	if (hrtick)
+		hrtick_clear(rq);
 
 	/*
 	 * Do the rq-clock update outside the rq lock:
@@ -4204,7 +4406,8 @@ need_resched_nonpreemptible:
 	} else
 		spin_unlock_irq(&rq->lock);
 
-	hrtick_set(rq);
+	if (hrtick)
+		hrtick_set(rq);
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
@@ -4586,10 +4789,8 @@ void set_user_nice(struct task_struct *p, long nice)
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		dec_load(rq, p);
-	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -4599,7 +4800,6 @@ void set_user_nice(struct task_struct *p, long nice)
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -5070,24 +5270,6 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 	return sched_setaffinity(pid, &new_mask);
 }
 
-/*
- * Represents all cpu's present in the system
- * In systems capable of hotplug, this map could dynamically grow
- * as new cpu's are detected in the system via any platform specific
- * method, such as ACPI for e.g.
- */
-
-cpumask_t cpu_present_map __read_mostly;
-EXPORT_SYMBOL(cpu_present_map);
-
-#ifndef CONFIG_SMP
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_online_map);
-
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_possible_map);
-#endif
-
 long sched_getaffinity(pid_t pid, cpumask_t *mask)
 {
 	struct task_struct *p;
@@ -5571,6 +5753,12 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
 		goto out;
 	}
 
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+		     !cpus_equal(p->cpus_allowed, *new_mask))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
@@ -6060,6 +6248,36 @@ static void unregister_sched_domain_sysctl(void)
 }
 #endif
 
+static void set_rq_online(struct rq *rq)
+{
+	if (!rq->online) {
+		const struct sched_class *class;
+
+		cpu_set(rq->cpu, rq->rd->online);
+		rq->online = 1;
+
+		for_each_class(class) {
+			if (class->rq_online)
+				class->rq_online(rq);
+		}
+	}
+}
+
+static void set_rq_offline(struct rq *rq)
+{
+	if (rq->online) {
+		const struct sched_class *class;
+
+		for_each_class(class) {
+			if (class->rq_offline)
+				class->rq_offline(rq);
+		}
+
+		cpu_clear(rq->cpu, rq->rd->online);
+		rq->online = 0;
+	}
+}
+
 /*
  * migration_call - callback that gets triggered when a CPU is added.
  * Here we can start up the necessary migration thread for the new CPU.
@@ -6097,7 +6315,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_set(cpu, rq->rd->online);
+
+			set_rq_online(rq);
 		}
 		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
@@ -6158,7 +6377,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_clear(cpu, rq->rd->online);
+			set_rq_offline(rq);
 		}
 		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
@@ -6192,6 +6411,28 @@ void __init migration_init(void)
 
 #ifdef CONFIG_SCHED_DEBUG
 
+static inline const char *sd_level_to_string(enum sched_domain_level lvl)
+{
+	switch (lvl) {
+	case SD_LV_NONE:
+			return "NONE";
+	case SD_LV_SIBLING:
+			return "SIBLING";
+	case SD_LV_MC:
+			return "MC";
+	case SD_LV_CPU:
+			return "CPU";
+	case SD_LV_NODE:
+			return "NODE";
+	case SD_LV_ALLNODES:
+			return "ALLNODES";
+	case SD_LV_MAX:
+			return "MAX";
+
+	}
+	return "MAX";
+}
+
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  cpumask_t *groupmask)
 {
@@ -6211,7 +6452,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s\n", str);
+	printk(KERN_CONT "span %s level %s\n",
+		str, sd_level_to_string(sd->level));
 
 	if (!cpu_isset(cpu, sd->span)) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -6295,9 +6537,9 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 	}
 	kfree(groupmask);
 }
-#else
+#else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
-#endif
+#endif /* CONFIG_SCHED_DEBUG */
 
 static int sd_degenerate(struct sched_domain *sd)
 {
@@ -6357,20 +6599,16 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 {
 	unsigned long flags;
-	const struct sched_class *class;
 
 	spin_lock_irqsave(&rq->lock, flags);
 
 	if (rq->rd) {
 		struct root_domain *old_rd = rq->rd;
 
-		for (class = sched_class_highest; class; class = class->next) {
-			if (class->leave_domain)
-				class->leave_domain(rq);
-		}
+		if (cpu_isset(rq->cpu, old_rd->online))
+			set_rq_offline(rq);
 
 		cpu_clear(rq->cpu, old_rd->span);
-		cpu_clear(rq->cpu, old_rd->online);
 
 		if (atomic_dec_and_test(&old_rd->refcount))
 			kfree(old_rd);
@@ -6381,12 +6619,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 
 	cpu_set(rq->cpu, rd->span);
 	if (cpu_isset(rq->cpu, cpu_online_map))
-		cpu_set(rq->cpu, rd->online);
-
-	for (class = sched_class_highest; class; class = class->next) {
-		if (class->join_domain)
-			class->join_domain(rq);
-	}
+		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
@@ -6397,6 +6630,8 @@ static void init_rootdomain(struct root_domain *rd)
 
 	cpus_clear(rd->span);
 	cpus_clear(rd->online);
+
+	cpupri_init(&rd->cpupri);
 }
 
 static void init_defrootdomain(void)
@@ -6591,7 +6826,7 @@ static void sched_domain_node_span(int node, cpumask_t *span)
 		cpus_or(*span, *span, *nodemask);
 	}
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
@@ -6610,7 +6845,7 @@ cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
 		*sg = &per_cpu(sched_group_cpus, cpu);
 	return cpu;
 }
-#endif
+#endif /* CONFIG_SCHED_SMT */
 
 /*
  * multi-core sched-domains:
@@ -6618,7 +6853,7 @@ cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
 #ifdef CONFIG_SCHED_MC
 static DEFINE_PER_CPU(struct sched_domain, core_domains);
 static DEFINE_PER_CPU(struct sched_group, sched_group_core);
-#endif
+#endif /* CONFIG_SCHED_MC */
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
@@ -6720,7 +6955,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 		sg = sg->next;
 	} while (sg != group_head);
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_NUMA
 /* Free memory allocated for various sched_group structures */
@@ -6757,11 +6992,11 @@ next_sg:
 		sched_group_nodes_bycpu[cpu] = NULL;
 	}
 }
-#else
+#else /* !CONFIG_NUMA */
 static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 {
 }
-#endif
+#endif /* CONFIG_NUMA */
 
 /*
  * Initialize sched groups cpu_power.
@@ -7470,7 +7705,7 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 #endif
 	return err;
 }
-#endif
+#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
 /*
  * Force a reinitialization of the sched domains hierarchy. The domains
@@ -7481,21 +7716,28 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 static int update_sched_domains(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
+	int cpu = (int)(long)hcpu;
+
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
+		disable_runtime(cpu_rq(cpu));
+		/* fall-through */
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
 		free_sched_domains();
 		return NOTIFY_OK;
 
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
+
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		enable_runtime(cpu_rq(cpu));
+		/* fall-through */
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		/*
@@ -7695,8 +7937,8 @@ void __init sched_init(void)
 
 		root_task_group.cfs_rq = (struct cfs_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
 		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
@@ -7710,8 +7952,8 @@ void __init sched_init(void)
 
 		root_task_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_RT_GROUP_SCHED */
 	}
 
 #ifdef CONFIG_SMP
@@ -7727,8 +7969,8 @@ void __init sched_init(void)
 #ifdef CONFIG_USER_SCHED
 	init_rt_bandwidth(&root_task_group.rt_bandwidth,
 			global_rt_period(), RUNTIME_INF);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
@@ -7738,8 +7980,8 @@ void __init sched_init(void)
 	INIT_LIST_HEAD(&root_task_group.children);
 	init_task_group.parent = &root_task_group;
 	list_add(&init_task_group.siblings, &root_task_group.children);
-#endif
-#endif
+#endif /* CONFIG_USER_SCHED */
+#endif /* CONFIG_GROUP_SCHED */
 
 	for_each_possible_cpu(i) {
 		struct rq *rq;
@@ -7819,6 +8061,7 @@ void __init sched_init(void)
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
 		rq->cpu = i;
+		rq->online = 0;
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
@@ -8058,7 +8301,7 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
 }
-#else
+#else /* !CONFG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
 {
 }
@@ -8076,7 +8319,7 @@ static inline void register_fair_sched_group(struct task_group *tg, int cpu)
 static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 }
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static void free_rt_sched_group(struct task_group *tg)
@@ -8147,7 +8390,7 @@ static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
 {
 	list_del_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list);
 }
-#else
+#else /* !CONFIG_RT_GROUP_SCHED */
 static inline void free_rt_sched_group(struct task_group *tg)
 {
 }
@@ -8165,7 +8408,7 @@ static inline void register_rt_sched_group(struct task_group *tg, int cpu)
 static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
 {
 }
-#endif
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_GROUP_SCHED
 static void free_sched_group(struct task_group *tg)
@@ -8276,17 +8519,14 @@ void sched_move_task(struct task_struct *tsk)
 
 	task_rq_unlock(rq, &flags);
 }
-#endif
+#endif /* CONFIG_GROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void set_se_shares(struct sched_entity *se, unsigned long shares)
+static void __set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
-	struct rq *rq = cfs_rq->rq;
 	int on_rq;
 
-	spin_lock_irq(&rq->lock);
-
 	on_rq = se->on_rq;
 	if (on_rq)
 		dequeue_entity(cfs_rq, se, 0);
@@ -8296,8 +8536,17 @@ static void set_se_shares(struct sched_entity *se, unsigned long shares)
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
+}
 
-	spin_unlock_irq(&rq->lock);
+static void set_se_shares(struct sched_entity *se, unsigned long shares)
+{
+	struct cfs_rq *cfs_rq = se->cfs_rq;
+	struct rq *rq = cfs_rq->rq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__set_se_shares(se, shares);
+	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 static DEFINE_MUTEX(shares_mutex);
@@ -8336,8 +8585,13 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	 * w/o tripping rebalance_share or load_balance_fair.
 	 */
 	tg->shares = shares;
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
+		/*
+		 * force a rebalance
+		 */
+		cfs_rq_set_shares(tg->cfs_rq[i], 0);
 		set_se_shares(tg->se[i], shares);
+	}
 
 	/*
 	 * Enable load balance activity on this group, by inserting it back on
@@ -8376,7 +8630,7 @@ static unsigned long to_ratio(u64 period, u64 runtime)
 #ifdef CONFIG_CGROUP_SCHED
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
-	struct task_group *tgi, *parent = tg ? tg->parent : NULL;
+	struct task_group *tgi, *parent = tg->parent;
 	unsigned long total = 0;
 
 	if (!parent) {
@@ -8400,7 +8654,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 	}
 	rcu_read_unlock();
 
-	return total + to_ratio(period, runtime) <
+	return total + to_ratio(period, runtime) <=
 		to_ratio(ktime_to_ns(parent->rt_bandwidth.rt_period),
 				parent->rt_bandwidth.rt_runtime);
 }
@@ -8520,16 +8774,21 @@ long sched_group_rt_period(struct task_group *tg)
 
 static int sched_rt_global_constraints(void)
 {
+	struct task_group *tg = &root_task_group;
+	u64 rt_runtime, rt_period;
 	int ret = 0;
 
+	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_runtime = tg->rt_bandwidth.rt_runtime;
+
 	mutex_lock(&rt_constraints_mutex);
-	if (!__rt_schedulable(NULL, 1, 0))
+	if (!__rt_schedulable(tg, rt_period, rt_runtime))
 		ret = -EINVAL;
 	mutex_unlock(&rt_constraints_mutex);
 
 	return ret;
 }
-#else
+#else /* !CONFIG_RT_GROUP_SCHED */
 static int sched_rt_global_constraints(void)
 {
 	unsigned long flags;
@@ -8547,7 +8806,7 @@ static int sched_rt_global_constraints(void)
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 int sched_rt_handler(struct ctl_table *table, int write,
 		struct file *filp, void __user *buffer, size_t *lenp,
@@ -8655,7 +8914,7 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 
 	return (u64) tg->shares;
 }
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
@@ -8679,7 +8938,7 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 {
 	return sched_group_rt_period(cgroup_tg(cgrp));
 }
-#endif
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ce05271..22ed55d 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -3,6 +3,9 @@
  *
  *  Copyright (C) 2008 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
+ *  Updates and enhancements:
+ *    Copyright (C) 2008 Red Hat, Inc. Steven Rostedt <srostedt@redhat.com>
+ *
  * Based on code by:
  *   Ingo Molnar <mingo@redhat.com>
  *   Guillaume Chazarain <guichaz@gmail.com>
@@ -32,6 +35,11 @@
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
+#define MULTI_SHIFT 15
+/* Max is double, Min is 1/2 */
+#define MAX_MULTI (2LL << MULTI_SHIFT)
+#define MIN_MULTI (1LL << (MULTI_SHIFT-1))
+
 struct sched_clock_data {
 	/*
 	 * Raw spinlock - this is a special case: this might be called
@@ -40,11 +48,15 @@ struct sched_clock_data {
 	 */
 	raw_spinlock_t		lock;
 
-	unsigned long		prev_jiffies;
+	unsigned long		tick_jiffies;
 	u64			prev_raw;
 	u64			tick_raw;
 	u64			tick_gtod;
 	u64			clock;
+	s64			multi;
+#ifdef CONFIG_NO_HZ
+	int			check_max;
+#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
@@ -71,41 +83,91 @@ void sched_clock_init(void)
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		scd->prev_jiffies = now_jiffies;
+		scd->tick_jiffies = now_jiffies;
 		scd->prev_raw = 0;
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
+		scd->multi = 1 << MULTI_SHIFT;
+#ifdef CONFIG_NO_HZ
+		scd->check_max = 1;
+#endif
 	}
 
 	sched_clock_running = 1;
 }
 
+#ifdef CONFIG_NO_HZ
+/*
+ * The dynamic ticks makes the delta jiffies inaccurate. This
+ * prevents us from checking the maximum time update.
+ * Disable the maximum check during stopped ticks.
+ */
+void sched_clock_tick_stop(int cpu)
+{
+	struct sched_clock_data *scd = cpu_sdc(cpu);
+
+	scd->check_max = 0;
+}
+
+void sched_clock_tick_start(int cpu)
+{
+	struct sched_clock_data *scd = cpu_sdc(cpu);
+
+	scd->check_max = 1;
+}
+
+static int check_max(struct sched_clock_data *scd)
+{
+	return scd->check_max;
+}
+#else
+static int check_max(struct sched_clock_data *scd)
+{
+	return 1;
+}
+#endif /* CONFIG_NO_HZ */
+
 /*
  * update the percpu scd from the raw @now value
  *
  *  - filter out backward motion
  *  - use jiffies to generate a min,max window to clip the raw values
  */
-static void __update_sched_clock(struct sched_clock_data *scd, u64 now)
+static void __update_sched_clock(struct sched_clock_data *scd, u64 now, u64 *time)
 {
 	unsigned long now_jiffies = jiffies;
-	long delta_jiffies = now_jiffies - scd->prev_jiffies;
+	long delta_jiffies = now_jiffies - scd->tick_jiffies;
 	u64 clock = scd->clock;
 	u64 min_clock, max_clock;
 	s64 delta = now - scd->prev_raw;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
+
+	/*
+	 * At schedule tick the clock can be just under the gtod. We don't
+	 * want to push it too prematurely.
+	 */
+	min_clock = scd->tick_gtod + (delta_jiffies * TICK_NSEC);
+	if (min_clock > TICK_NSEC)
+		min_clock -= TICK_NSEC / 2;
 
 	if (unlikely(delta < 0)) {
 		clock++;
 		goto out;
 	}
 
-	max_clock = min_clock + TICK_NSEC;
+	/*
+	 * The clock must stay within a jiffie of the gtod.
+	 * But since we may be at the start of a jiffy or the end of one
+	 * we add another jiffy buffer.
+	 */
+	max_clock = scd->tick_gtod + (2 + delta_jiffies) * TICK_NSEC;
+
+	delta *= scd->multi;
+	delta >>= MULTI_SHIFT;
 
-	if (unlikely(clock + delta > max_clock)) {
+	if (unlikely(clock + delta > max_clock) && check_max(scd)) {
 		if (clock < max_clock)
 			clock = max_clock;
 		else
@@ -118,9 +180,12 @@ static void __update_sched_clock(struct sched_clock_data *scd, u64 now)
 	if (unlikely(clock < min_clock))
 		clock = min_clock;
 
-	scd->prev_raw = now;
-	scd->prev_jiffies = now_jiffies;
-	scd->clock = clock;
+	if (time)
+		*time = clock;
+	else {
+		scd->prev_raw = now;
+		scd->clock = clock;
+	}
 }
 
 static void lock_double_clock(struct sched_clock_data *data1,
@@ -160,25 +225,30 @@ u64 sched_clock_cpu(int cpu)
 		now -= my_scd->tick_raw;
 		now += scd->tick_raw;
 
-		now -= my_scd->tick_gtod;
-		now += scd->tick_gtod;
+		now += my_scd->tick_gtod;
+		now -= scd->tick_gtod;
 
 		__raw_spin_unlock(&my_scd->lock);
+
+		__update_sched_clock(scd, now, &clock);
+
+		__raw_spin_unlock(&scd->lock);
+
 	} else {
 		__raw_spin_lock(&scd->lock);
+		__update_sched_clock(scd, now, NULL);
+		clock = scd->clock;
+		__raw_spin_unlock(&scd->lock);
 	}
 
-	__update_sched_clock(scd, now);
-	clock = scd->clock;
-
-	__raw_spin_unlock(&scd->lock);
-
 	return clock;
 }
 
 void sched_clock_tick(void)
 {
 	struct sched_clock_data *scd = this_scd();
+	unsigned long now_jiffies = jiffies;
+	s64 mult, delta_gtod, delta_raw;
 	u64 now, now_gtod;
 
 	if (unlikely(!sched_clock_running))
@@ -186,18 +256,33 @@ void sched_clock_tick(void)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	now = sched_clock();
 	now_gtod = ktime_to_ns(ktime_get());
+	now = sched_clock();
 
 	__raw_spin_lock(&scd->lock);
-	__update_sched_clock(scd, now);
+	__update_sched_clock(scd, now, NULL);
 	/*
 	 * update tick_gtod after __update_sched_clock() because that will
 	 * already observe 1 new jiffy; adding a new tick_gtod to that would
 	 * increase the clock 2 jiffies.
 	 */
+	delta_gtod = now_gtod - scd->tick_gtod;
+	delta_raw = now - scd->tick_raw;
+
+	if ((long)delta_raw > 0) {
+		mult = delta_gtod << MULTI_SHIFT;
+		do_div(mult, delta_raw);
+		scd->multi = mult;
+		if (scd->multi > MAX_MULTI)
+			scd->multi = MAX_MULTI;
+		else if (scd->multi < MIN_MULTI)
+			scd->multi = MIN_MULTI;
+	} else
+		scd->multi = 1 << MULTI_SHIFT;
+
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
+	scd->tick_jiffies = now_jiffies;
 	__raw_spin_unlock(&scd->lock);
 }
 
@@ -227,6 +312,7 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 	__raw_spin_lock(&scd->lock);
 	scd->prev_raw = now;
 	scd->clock += delta_ns;
+	scd->multi = 1 << MULTI_SHIFT;
 	__raw_spin_unlock(&scd->lock);
 
 	touch_softlockup_watchdog();
@@ -244,3 +330,16 @@ unsigned long long __attribute__((weak)) sched_clock(void)
 {
 	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
 }
+
+unsigned long long cpu_clock(int cpu)
+{
+	unsigned long long clock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(cpu);
+	local_irq_restore(flags);
+
+	return clock;
+}
+EXPORT_SYMBOL_GPL(cpu_clock);
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
new file mode 100644
index 0000000..52154fe
--- /dev/null
+++ b/kernel/sched_cpupri.c
@@ -0,0 +1,174 @@
+/*
+ *  kernel/sched_cpupri.c
+ *
+ *  CPU priority management
+ *
+ *  Copyright (C) 2007-2008 Novell
+ *
+ *  Author: Gregory Haskins <ghaskins@novell.com>
+ *
+ *  This code tracks the priority of each CPU so that global migration
+ *  decisions are easy to calculate.  Each CPU can be in a state as follows:
+ *
+ *                 (INVALID), IDLE, NORMAL, RT1, ... RT99
+ *
+ *  going from the lowest priority to the highest.  CPUs in the INVALID state
+ *  are not eligible for routing.  The system maintains this state with
+ *  a 2 dimensional bitmap (the first for priority class, the second for cpus
+ *  in that class).  Therefore a typical application without affinity
+ *  restrictions can find a suitable CPU with O(1) complexity (e.g. two bit
+ *  searches).  For tasks with affinity restrictions, the algorithm has a
+ *  worst case complexity of O(min(102, nr_domcpus)), though the scenario that
+ *  yields the worst case search is fairly contrived.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; version 2
+ *  of the License.
+ */
+
+#include "sched_cpupri.h"
+
+/* Convert between a 140 based task->prio, and our 102 based cpupri */
+static int convert_prio(int prio)
+{
+	int cpupri;
+
+	if (prio == CPUPRI_INVALID)
+		cpupri = CPUPRI_INVALID;
+	else if (prio == MAX_PRIO)
+		cpupri = CPUPRI_IDLE;
+	else if (prio >= MAX_RT_PRIO)
+		cpupri = CPUPRI_NORMAL;
+	else
+		cpupri = MAX_RT_PRIO - prio + 1;
+
+	return cpupri;
+}
+
+#define for_each_cpupri_active(array, idx)                    \
+  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
+       idx < CPUPRI_NR_PRIORITIES;                            \
+       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+
+/**
+ * cpupri_find - find the best (lowest-pri) CPU in the system
+ * @cp: The cpupri context
+ * @p: The task
+ * @lowest_mask: A mask to fill in with selected CPUs
+ *
+ * Note: This function returns the recommended CPUs as calculated during the
+ * current invokation.  By the time the call returns, the CPUs may have in
+ * fact changed priorities any number of times.  While not ideal, it is not
+ * an issue of correctness since the normal rebalancer logic will correct
+ * any discrepancies created by racing against the uncertainty of the current
+ * priority configuration.
+ *
+ * Returns: (int)bool - CPUs were found
+ */
+int cpupri_find(struct cpupri *cp, struct task_struct *p,
+		cpumask_t *lowest_mask)
+{
+	int                  idx      = 0;
+	int                  task_pri = convert_prio(p->prio);
+
+	for_each_cpupri_active(cp->pri_active, idx) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
+		cpumask_t mask;
+
+		if (idx >= task_pri)
+			break;
+
+		cpus_and(mask, p->cpus_allowed, vec->mask);
+
+		if (cpus_empty(mask))
+			continue;
+
+		*lowest_mask = mask;
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * cpupri_set - update the cpu priority setting
+ * @cp: The cpupri context
+ * @cpu: The target cpu
+ * @pri: The priority (INVALID-RT99) to assign to this CPU
+ *
+ * Note: Assumes cpu_rq(cpu)->lock is locked
+ *
+ * Returns: (void)
+ */
+void cpupri_set(struct cpupri *cp, int cpu, int newpri)
+{
+	int                 *currpri = &cp->cpu_to_pri[cpu];
+	int                  oldpri  = *currpri;
+	unsigned long        flags;
+
+	newpri = convert_prio(newpri);
+
+	BUG_ON(newpri >= CPUPRI_NR_PRIORITIES);
+
+	if (newpri == oldpri)
+		return;
+
+	/*
+	 * If the cpu was currently mapped to a different value, we
+	 * first need to unmap the old value
+	 */
+	if (likely(oldpri != CPUPRI_INVALID)) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		vec->count--;
+		if (!vec->count)
+			clear_bit(oldpri, cp->pri_active);
+		cpu_clear(cpu, vec->mask);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
+
+	if (likely(newpri != CPUPRI_INVALID)) {
+		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		cpu_set(cpu, vec->mask);
+		vec->count++;
+		if (vec->count == 1)
+			set_bit(newpri, cp->pri_active);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
+
+	*currpri = newpri;
+}
+
+/**
+ * cpupri_init - initialize the cpupri structure
+ * @cp: The cpupri context
+ *
+ * Returns: (void)
+ */
+void cpupri_init(struct cpupri *cp)
+{
+	int i;
+
+	memset(cp, 0, sizeof(*cp));
+
+	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
+		struct cpupri_vec *vec = &cp->pri_to_cpu[i];
+
+		spin_lock_init(&vec->lock);
+		vec->count = 0;
+		cpus_clear(vec->mask);
+	}
+
+	for_each_possible_cpu(i)
+		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+}
+
+
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
new file mode 100644
index 0000000..f25811b
--- /dev/null
+++ b/kernel/sched_cpupri.h
@@ -0,0 +1,36 @@
+#ifndef _LINUX_CPUPRI_H
+#define _LINUX_CPUPRI_H
+
+#include <linux/sched.h>
+
+#define CPUPRI_NR_PRIORITIES	(MAX_RT_PRIO + 2)
+#define CPUPRI_NR_PRI_WORDS	BITS_TO_LONGS(CPUPRI_NR_PRIORITIES)
+
+#define CPUPRI_INVALID -1
+#define CPUPRI_IDLE     0
+#define CPUPRI_NORMAL   1
+/* values 2-101 are RT priorities 0-99 */
+
+struct cpupri_vec {
+	spinlock_t lock;
+	int        count;
+	cpumask_t  mask;
+};
+
+struct cpupri {
+	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
+	long              pri_active[CPUPRI_NR_PRI_WORDS];
+	int               cpu_to_pri[NR_CPUS];
+};
+
+#ifdef CONFIG_SMP
+int  cpupri_find(struct cpupri *cp,
+		 struct task_struct *p, cpumask_t *lowest_mask);
+void cpupri_set(struct cpupri *cp, int cpu, int pri);
+void cpupri_init(struct cpupri *cp);
+#else
+#define cpupri_set(cp, cpu, pri) do { } while (0)
+#define cpupri_init() do { } while (0)
+#endif
+
+#endif /* _LINUX_CPUPRI_H */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 8bb7130..bbe6b31 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -119,9 +119,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	struct sched_entity *last;
 	unsigned long flags;
 
-#if !defined(CONFIG_CGROUP_SCHED) || !defined(CONFIG_USER_SCHED)
-	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
-#else
+#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
 	char path[128] = "";
 	struct cgroup *cgroup = NULL;
 	struct task_group *tg = cfs_rq->tg;
@@ -133,6 +131,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 		cgroup_path(cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
+#else
+	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #endif
 
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
@@ -162,11 +162,64 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_SCHEDSTATS
-	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
-			rq->bkl_count);
+#define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+
+	P(yld_exp_empty);
+	P(yld_act_empty);
+	P(yld_both_empty);
+	P(yld_count);
+
+	P(sched_switch);
+	P(sched_count);
+	P(sched_goidle);
+
+	P(ttwu_count);
+	P(ttwu_local);
+
+	P(bkl_count);
+
+#undef P
 #endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_SMP
+	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
+#endif
+#endif
+}
+
+void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
+{
+#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
+	char path[128] = "";
+	struct cgroup *cgroup = NULL;
+	struct task_group *tg = rt_rq->tg;
+
+	if (tg)
+		cgroup = tg->css.cgroup;
+
+	if (cgroup)
+		cgroup_path(cgroup, path, sizeof(path));
+
+	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
+#else
+	SEQ_printf(m, "\nrt_rq[%d]:\n", cpu);
+#endif
+
+
+#define P(x) \
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rt_rq->x))
+#define PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rt_rq->x))
+
+	P(rt_nr_running);
+	P(rt_throttled);
+	PN(rt_time);
+	PN(rt_runtime);
+
+#undef PN
+#undef P
 }
 
 static void print_cpu(struct seq_file *m, int cpu)
@@ -208,6 +261,7 @@ static void print_cpu(struct seq_file *m, int cpu)
 #undef PN
 
 	print_cfs_stats(m, cpu);
+	print_rt_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 08ae848..f2aa987 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -63,13 +63,13 @@ unsigned int __read_mostly sysctl_sched_compat_yield;
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 5 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity = 10000000UL;
+unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -334,6 +334,34 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 #endif
 
 /*
+ * delta *= w / rw
+ */
+static inline unsigned long
+calc_delta_weight(unsigned long delta, struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		delta = calc_delta_mine(delta,
+				se->load.weight, &cfs_rq_of(se)->load);
+	}
+
+	return delta;
+}
+
+/*
+ * delta *= rw / w
+ */
+static inline unsigned long
+calc_delta_fair(unsigned long delta, struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		delta = calc_delta_mine(delta,
+				cfs_rq_of(se)->load.weight, &se->load);
+	}
+
+	return delta;
+}
+
+/*
  * The idea is to set a period in which each task runs once.
  *
  * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
@@ -362,47 +390,80 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 slice = __sched_period(cfs_rq->nr_running);
-
-	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-
-		slice *= se->load.weight;
-		do_div(slice, cfs_rq->load.weight);
-	}
-
-
-	return slice;
+	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s/w = p/rw
+ * vs = s*rw/w = p
  */
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long nr_running = cfs_rq->nr_running;
-	unsigned long weight;
-	u64 vslice;
 
 	if (!se->on_rq)
 		nr_running++;
 
-	vslice = __sched_period(nr_running);
+	return __sched_period(nr_running);
+}
+
+/*
+ * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
+ * that it favours >=0 over <0.
+ *
+ *   -20         |
+ *               |
+ *     0 --------+-------
+ *             .'
+ *    19     .'
+ *
+ */
+static unsigned long
+calc_delta_asym(unsigned long delta, struct sched_entity *se)
+{
+	struct load_weight lw = {
+		.weight = NICE_0_LOAD,
+		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
+	};
 
 	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
+		struct load_weight *se_lw = &se->load;
+		unsigned long rw = cfs_rq_of(se)->load.weight;
+
+#ifdef CONFIG_FAIR_SCHED_GROUP
+		struct cfs_rq *cfs_rq = se->my_q;
+		struct task_group *tg = NULL
+
+		if (cfs_rq)
+			tg = cfs_rq->tg;
+
+		if (tg && tg->shares < NICE_0_LOAD) {
+			/*
+			 * scale shares to what it would have been had
+			 * tg->weight been NICE_0_LOAD:
+			 *
+			 *   weight = 1024 * shares / tg->weight
+			 */
+			lw.weight *= se->load.weight;
+			lw.weight /= tg->shares;
+
+			lw.inv_weight = 0;
+
+			se_lw = &lw;
+			rw += lw.weight - se->load.weight;
+		} else
+#endif
 
-		weight = cfs_rq->load.weight;
-		if (!se->on_rq)
-			weight += se->load.weight;
+		if (se->load.weight < NICE_0_LOAD) {
+			se_lw = &lw;
+			rw += NICE_0_LOAD - se->load.weight;
+		}
 
-		vslice *= NICE_0_LOAD;
-		do_div(vslice, weight);
+		delta = calc_delta_mine(delta, rw, se_lw);
 	}
 
-	return vslice;
+	return delta;
 }
 
 /*
@@ -419,11 +480,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = delta_exec;
-	if (unlikely(curr->load.weight != NICE_0_LOAD)) {
-		delta_exec_weighted = calc_delta_fair(delta_exec_weighted,
-							&curr->load);
-	}
+	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
 }
 
@@ -510,10 +567,27 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * Scheduling class queueing methods:
  */
 
+#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+static void
+add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
+{
+	cfs_rq->task_weight += weight;
+}
+#else
+static inline void
+add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
+{
+}
+#endif
+
 static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
+	if (!parent_entity(se))
+		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
+	if (entity_is_task(se))
+		add_cfs_task_weight(cfs_rq, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
 	list_add(&se->group_node, &cfs_rq->tasks);
@@ -523,6 +597,10 @@ static void
 account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_sub(&cfs_rq->load, se->load.weight);
+	if (!parent_entity(se))
+		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
+	if (entity_is_task(se))
+		add_cfs_task_weight(cfs_rq, -se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
 	list_del_init(&se->group_node);
@@ -609,8 +687,17 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS))
-			vruntime -= sysctl_sched_latency;
+		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+			unsigned long thresh = sysctl_sched_latency;
+
+			/*
+			 * convert the sleeper threshold into virtual time
+			 */
+			if (sched_feat(NORMALIZED_SLEEPER))
+				thresh = calc_delta_fair(thresh, se);
+
+			vruntime -= thresh;
+		}
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
@@ -639,21 +726,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 		__enqueue_entity(cfs_rq, se);
 }
 
-static void update_avg(u64 *avg, u64 sample)
-{
-	s64 diff = sample - *avg;
-	*avg += diff >> 3;
-}
-
-static void update_avg_stats(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	if (!se->last_wakeup)
-		return;
-
-	update_avg(&se->avg_overlap, se->sum_exec_runtime - se->last_wakeup);
-	se->last_wakeup = 0;
-}
-
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
@@ -664,7 +736,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
-		update_avg_stats(cfs_rq, se);
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
@@ -726,17 +797,16 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
-
 static struct sched_entity *
 pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (!cfs_rq->next)
-		return se;
+	struct rq *rq = rq_of(cfs_rq);
+	u64 pair_slice = rq->clock - cfs_rq->pair_start;
 
-	if (wakeup_preempt_entity(cfs_rq->next, se) != 0)
+	if (!cfs_rq->next || pair_slice > sched_slice(cfs_rq, cfs_rq->next)) {
+		cfs_rq->pair_start = rq->clock;
 		return se;
+	}
 
 	return cfs_rq->next;
 }
@@ -835,7 +905,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 		hrtick_start(rq, delta, requeue);
 	}
 }
-#else
+#else /* !CONFIG_SCHED_HRTICK */
 static inline void
 hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
@@ -976,7 +1046,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	}
 	return cpu;
 }
-#else
+#else /* !ARCH_HAS_SCHED_WAKE_IDLE*/
 static inline int wake_idle(int cpu, struct task_struct *p)
 {
 	return cpu;
@@ -987,6 +1057,89 @@ static inline int wake_idle(int cpu, struct task_struct *p)
 
 static const struct sched_class fair_sched_class;
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/*
+ * effective_load() calculates the load change as seen from the root_task_group
+ *
+ * Adding load to a group doesn't make a group heavier, but can cause movement
+ * of group shares between cpus. Assuming the shares were perfectly aligned one
+ * can calculate the shift in shares.
+ *
+ * The problem is that perfectly aligning the shares is rather expensive, hence
+ * we try to avoid doing that too often - see update_shares(), which ratelimits
+ * this change.
+ *
+ * We compensate this by not only taking the current delta into account, but
+ * also considering the delta between when the shares were last adjusted and
+ * now.
+ *
+ * We still saw a performance dip, some tracing learned us that between
+ * cgroup:/ and cgroup:/foo balancing the number of affine wakeups increased
+ * significantly. Therefore try to bias the error in direction of failing
+ * the affine wakeup.
+ *
+ */
+static long effective_load(struct task_group *tg, int cpu,
+		long wl, long wg)
+{
+	struct sched_entity *se = tg->se[cpu];
+	long more_w;
+
+	if (!tg->parent)
+		return wl;
+
+	/*
+	 * By not taking the decrease of shares on the other cpu into
+	 * account our error leans towards reducing the affine wakeups.
+	 */
+	if (!wl && sched_feat(ASYM_EFF_LOAD))
+		return wl;
+
+	/*
+	 * Instead of using this increment, also add the difference
+	 * between when the shares were last updated and now.
+	 */
+	more_w = se->my_q->load.weight - se->my_q->rq_weight;
+	wl += more_w;
+	wg += more_w;
+
+	for_each_sched_entity(se) {
+#define D(n) (likely(n) ? (n) : 1)
+
+		long S, rw, s, a, b;
+
+		S = se->my_q->tg->shares;
+		s = se->my_q->shares;
+		rw = se->my_q->rq_weight;
+
+		a = S*(rw + wl);
+		b = S*rw + s*wg;
+
+		wl = s*(a-b)/D(b);
+		/*
+		 * Assume the group is already running and will
+		 * thus already be accounted for in the weight.
+		 *
+		 * That is, moving shares between CPUs, does not
+		 * alter the group weight.
+		 */
+		wg = 0;
+#undef D
+	}
+
+	return wl;
+}
+
+#else
+
+static inline unsigned long effective_load(struct task_group *tg, int cpu,
+		unsigned long wl, unsigned long wg)
+{
+	return wl;
+}
+
+#endif
+
 static int
 wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
@@ -994,8 +1147,10 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	    unsigned int imbalance)
 {
 	struct task_struct *curr = this_rq->curr;
+	struct task_group *tg;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
+	unsigned long weight;
 	int balanced;
 
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
@@ -1006,19 +1161,28 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
-	if (sync)
-		tl -= current->se.load.weight;
+	if (sync) {
+		tg = task_group(current);
+		weight = current->se.load.weight;
+
+		tl += effective_load(tg, this_cpu, -weight, -weight);
+		load += effective_load(tg, prev_cpu, 0, -weight);
+	}
 
-	balanced = 100*(tl + p->se.load.weight) <= imbalance*load;
+	tg = task_group(p);
+	weight = p->se.load.weight;
+
+	balanced = 100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
+		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*
 	 * If the currently running task will sleep within
 	 * a reasonable amount of time then attract this newly
 	 * woken task:
 	 */
-	if (sync && balanced && curr->sched_class == &fair_sched_class) {
+	if (sync && balanced) {
 		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
-				p->se.avg_overlap < sysctl_sched_migration_cost)
+		    p->se.avg_overlap < sysctl_sched_migration_cost)
 			return 1;
 	}
 
@@ -1111,11 +1275,13 @@ static unsigned long wakeup_gran(struct sched_entity *se)
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
 	/*
-	 * More easily preempt - nice tasks, while not making
-	 * it harder for + nice tasks.
+	 * More easily preempt - nice tasks, while not making it harder for
+	 * + nice tasks.
 	 */
-	if (unlikely(se->load.weight > NICE_0_LOAD))
-		gran = calc_delta_fair(gran, &se->load);
+	if (sched_feat(ASYM_GRAN))
+		gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	else
+		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
 
 	return gran;
 }
@@ -1177,7 +1343,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 		return;
 	}
 
-	se->last_wakeup = se->sum_exec_runtime;
 	if (unlikely(se == pse))
 		return;
 
@@ -1275,23 +1440,18 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 	struct task_struct *p = NULL;
 	struct sched_entity *se;
 
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
-	/* Skip over entities that are not tasks */
-	do {
+	while (next != &cfs_rq->tasks) {
 		se = list_entry(next, struct sched_entity, group_node);
 		next = next->next;
-	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	if (next == &cfs_rq->tasks)
-		return NULL;
+		/* Skip over entities that are not tasks */
+		if (entity_is_task(se)) {
+			p = task_of(se);
+			break;
+		}
+	}
 
 	cfs_rq->balance_iterator = next;
-
-	if (entity_is_task(se))
-		p = task_of(se);
-
 	return p;
 }
 
@@ -1309,75 +1469,82 @@ static struct task_struct *load_balance_next_fair(void *arg)
 	return __load_balance_iterator(cfs_rq, cfs_rq->balance_iterator);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
+static unsigned long
+__load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		unsigned long max_load_move, struct sched_domain *sd,
+		enum cpu_idle_type idle, int *all_pinned, int *this_best_prio,
+		struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *curr;
-	struct task_struct *p;
-
-	if (!cfs_rq->nr_running || !first_fair(cfs_rq))
-		return MAX_PRIO;
-
-	curr = cfs_rq->curr;
-	if (!curr)
-		curr = __pick_next_entity(cfs_rq);
+	struct rq_iterator cfs_rq_iterator;
 
-	p = task_of(curr);
+	cfs_rq_iterator.start = load_balance_start_fair;
+	cfs_rq_iterator.next = load_balance_next_fair;
+	cfs_rq_iterator.arg = cfs_rq;
 
-	return p->prio;
+	return balance_tasks(this_rq, this_cpu, busiest,
+			max_load_move, sd, idle, all_pinned,
+			this_best_prio, &cfs_rq_iterator);
 }
-#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
 		  int *all_pinned, int *this_best_prio)
 {
-	struct cfs_rq *busy_cfs_rq;
 	long rem_load_move = max_load_move;
-	struct rq_iterator cfs_rq_iterator;
-
-	cfs_rq_iterator.start = load_balance_start_fair;
-	cfs_rq_iterator.next = load_balance_next_fair;
+	int busiest_cpu = cpu_of(busiest);
+	struct task_group *tg;
 
-	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
-#ifdef CONFIG_FAIR_GROUP_SCHED
-		struct cfs_rq *this_cfs_rq;
-		long imbalance;
-		unsigned long maxload;
+	rcu_read_lock();
+	update_h_load(busiest_cpu);
 
-		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
+	list_for_each_entry(tg, &task_groups, list) {
+		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
+		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
+		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
+		u64 rem_load, moved_load;
 
-		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
-		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
-		if (imbalance <= 0)
+		/*
+		 * empty group
+		 */
+		if (!busiest_cfs_rq->task_weight)
 			continue;
 
-		/* Don't pull more than imbalance/2 */
-		imbalance /= 2;
-		maxload = min(rem_load_move, imbalance);
+		rem_load = (u64)rem_load_move * busiest_weight;
+		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
-		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
-#else
-# define maxload rem_load_move
-#endif
-		/*
-		 * pass busy_cfs_rq argument into
-		 * load_balance_[start|next]_fair iterators
-		 */
-		cfs_rq_iterator.arg = busy_cfs_rq;
-		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
-					       maxload, sd, idle, all_pinned,
-					       this_best_prio,
-					       &cfs_rq_iterator);
+		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
+				rem_load, sd, idle, all_pinned, this_best_prio,
+				tg->cfs_rq[busiest_cpu]);
+
+		if (!moved_load)
+			continue;
+
+		moved_load *= busiest_h_load;
+		moved_load = div_u64(moved_load, busiest_weight + 1);
 
-		if (rem_load_move <= 0)
+		rem_load_move -= moved_load;
+		if (rem_load_move < 0)
 			break;
 	}
+	rcu_read_unlock();
 
 	return max_load_move - rem_load_move;
 }
+#else
+static unsigned long
+load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		  unsigned long max_load_move,
+		  struct sched_domain *sd, enum cpu_idle_type idle,
+		  int *all_pinned, int *this_best_prio)
+{
+	return __load_balance_fair(this_rq, this_cpu, busiest,
+			max_load_move, sd, idle, all_pinned,
+			this_best_prio, &busiest->cfs);
+}
+#endif
 
 static int
 move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
@@ -1402,7 +1569,7 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * scheduler tick hitting a task of our scheduling class:
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 1c7283c..862b06b 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,4 +1,5 @@
 SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
+SCHED_FEAT(NORMALIZED_SLEEPER, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
@@ -6,5 +7,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 1)
 SCHED_FEAT(DOUBLE_TICK, 0)
-SCHED_FEAT(NORMALIZED_SLEEPER, 1)
-SCHED_FEAT(DEADLINE, 1)
+SCHED_FEAT(ASYM_GRAN, 1)
+SCHED_FEAT(LB_BIAS, 0)
+SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
+SCHED_FEAT(ASYM_EFF_LOAD, 1)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0f3c191..47ceac9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -12,6 +12,9 @@ static inline int rt_overloaded(struct rq *rq)
 
 static inline void rt_set_overload(struct rq *rq)
 {
+	if (!rq->online)
+		return;
+
 	cpu_set(rq->cpu, rq->rd->rto_mask);
 	/*
 	 * Make sure the mask is visible before we set
@@ -26,6 +29,9 @@ static inline void rt_set_overload(struct rq *rq)
 
 static inline void rt_clear_overload(struct rq *rq)
 {
+	if (!rq->online)
+		return;
+
 	/* the order here really doesn't matter */
 	atomic_dec(&rq->rd->rto_count);
 	cpu_clear(rq->cpu, rq->rd->rto_mask);
@@ -155,7 +161,7 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 	return &rt_rq->tg->rt_bandwidth;
 }
 
-#else
+#else /* !CONFIG_RT_GROUP_SCHED */
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
@@ -220,49 +226,10 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 	return &def_rt_bandwidth;
 }
 
-#endif
-
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
-{
-	int i, idle = 1;
-	cpumask_t span;
-
-	if (rt_b->rt_runtime == RUNTIME_INF)
-		return 1;
-
-	span = sched_rt_period_mask();
-	for_each_cpu_mask(i, span) {
-		int enqueue = 0;
-		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
-		spin_lock(&rq->lock);
-		if (rt_rq->rt_time) {
-			u64 runtime;
-
-			spin_lock(&rt_rq->rt_runtime_lock);
-			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
-				enqueue = 1;
-			}
-			if (rt_rq->rt_time || rt_rq->rt_nr_running)
-				idle = 0;
-			spin_unlock(&rt_rq->rt_runtime_lock);
-		} else if (rt_rq->rt_nr_running)
-			idle = 0;
-
-		if (enqueue)
-			sched_rt_rq_enqueue(rt_rq);
-		spin_unlock(&rq->lock);
-	}
-
-	return idle;
-}
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
-static int balance_runtime(struct rt_rq *rt_rq)
+static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
@@ -281,6 +248,9 @@ static int balance_runtime(struct rt_rq *rt_rq)
 			continue;
 
 		spin_lock(&iter->rt_runtime_lock);
+		if (iter->rt_runtime == RUNTIME_INF)
+			goto next;
+
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
 			do_div(diff, weight);
@@ -294,13 +264,163 @@ static int balance_runtime(struct rt_rq *rt_rq)
 				break;
 			}
 		}
+next:
 		spin_unlock(&iter->rt_runtime_lock);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
 
 	return more;
 }
-#endif
+
+static void __disable_runtime(struct rq *rq)
+{
+	struct root_domain *rd = rq->rd;
+	struct rt_rq *rt_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+		s64 want;
+		int i;
+
+		spin_lock(&rt_b->rt_runtime_lock);
+		spin_lock(&rt_rq->rt_runtime_lock);
+		if (rt_rq->rt_runtime == RUNTIME_INF ||
+				rt_rq->rt_runtime == rt_b->rt_runtime)
+			goto balanced;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+
+		want = rt_b->rt_runtime - rt_rq->rt_runtime;
+
+		for_each_cpu_mask(i, rd->span) {
+			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
+			s64 diff;
+
+			if (iter == rt_rq)
+				continue;
+
+			spin_lock(&iter->rt_runtime_lock);
+			if (want > 0) {
+				diff = min_t(s64, iter->rt_runtime, want);
+				iter->rt_runtime -= diff;
+				want -= diff;
+			} else {
+				iter->rt_runtime -= want;
+				want -= want;
+			}
+			spin_unlock(&iter->rt_runtime_lock);
+
+			if (!want)
+				break;
+		}
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		BUG_ON(want);
+balanced:
+		rt_rq->rt_runtime = RUNTIME_INF;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		spin_unlock(&rt_b->rt_runtime_lock);
+	}
+}
+
+static void disable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__disable_runtime(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static void __enable_runtime(struct rq *rq)
+{
+	struct rt_rq *rt_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+		spin_lock(&rt_b->rt_runtime_lock);
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = rt_b->rt_runtime;
+		rt_rq->rt_time = 0;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		spin_unlock(&rt_b->rt_runtime_lock);
+	}
+}
+
+static void enable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__enable_runtime(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static int balance_runtime(struct rt_rq *rt_rq)
+{
+	int more = 0;
+
+	if (rt_rq->rt_time > rt_rq->rt_runtime) {
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		more = do_balance_runtime(rt_rq);
+		spin_lock(&rt_rq->rt_runtime_lock);
+	}
+
+	return more;
+}
+#else /* !CONFIG_SMP */
+static inline int balance_runtime(struct rt_rq *rt_rq)
+{
+	return 0;
+}
+#endif /* CONFIG_SMP */
+
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
+{
+	int i, idle = 1;
+	cpumask_t span;
+
+	if (rt_b->rt_runtime == RUNTIME_INF)
+		return 1;
+
+	span = sched_rt_period_mask();
+	for_each_cpu_mask(i, span) {
+		int enqueue = 0;
+		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
+		struct rq *rq = rq_of_rt_rq(rt_rq);
+
+		spin_lock(&rq->lock);
+		if (rt_rq->rt_time) {
+			u64 runtime;
+
+			spin_lock(&rt_rq->rt_runtime_lock);
+			if (rt_rq->rt_throttled)
+				balance_runtime(rt_rq);
+			runtime = rt_rq->rt_runtime;
+			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
+			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
+				rt_rq->rt_throttled = 0;
+				enqueue = 1;
+			}
+			if (rt_rq->rt_time || rt_rq->rt_nr_running)
+				idle = 0;
+			spin_unlock(&rt_rq->rt_runtime_lock);
+		} else if (rt_rq->rt_nr_running)
+			idle = 0;
+
+		if (enqueue)
+			sched_rt_rq_enqueue(rt_rq);
+		spin_unlock(&rq->lock);
+	}
+
+	return idle;
+}
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 {
@@ -327,18 +447,10 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
 		return 0;
 
-#ifdef CONFIG_SMP
-	if (rt_rq->rt_time > runtime) {
-		int more;
-
-		spin_unlock(&rt_rq->rt_runtime_lock);
-		more = balance_runtime(rt_rq);
-		spin_lock(&rt_rq->rt_runtime_lock);
-
-		if (more)
-			runtime = sched_rt_runtime(rt_rq);
-	}
-#endif
+	balance_runtime(rt_rq);
+	runtime = sched_rt_runtime(rt_rq);
+	if (runtime == RUNTIME_INF)
+		return 0;
 
 	if (rt_rq->rt_time > runtime) {
 		rt_rq->rt_throttled = 1;
@@ -392,12 +504,21 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	if (rt_se_prio(rt_se) < rt_rq->highest_prio)
+	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
+		struct rq *rq = rq_of_rt_rq(rt_rq);
+
 		rt_rq->highest_prio = rt_se_prio(rt_se);
+#ifdef CONFIG_SMP
+		if (rq->online)
+			cpupri_set(&rq->rd->cpupri, rq->cpu,
+				   rt_se_prio(rt_se));
+#endif
+	}
 #endif
 #ifdef CONFIG_SMP
 	if (rt_se->nr_cpus_allowed > 1) {
 		struct rq *rq = rq_of_rt_rq(rt_rq);
+
 		rq->rt.rt_nr_migratory++;
 	}
 
@@ -417,6 +538,10 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 static inline
 void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+#ifdef CONFIG_SMP
+	int highest_prio = rt_rq->highest_prio;
+#endif
+
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	WARN_ON(!rt_rq->rt_nr_running);
 	rt_rq->rt_nr_running--;
@@ -440,6 +565,14 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 		rq->rt.rt_nr_migratory--;
 	}
 
+	if (rt_rq->highest_prio != highest_prio) {
+		struct rq *rq = rq_of_rt_rq(rt_rq);
+
+		if (rq->online)
+			cpupri_set(&rq->rd->cpupri, rq->cpu,
+				   rt_rq->highest_prio);
+	}
+
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif /* CONFIG_SMP */
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -455,6 +588,7 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
+	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
 	/*
 	 * Don't enqueue the group if its throttled, or when empty.
@@ -465,7 +599,11 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	if (rt_se->nr_cpus_allowed == 1)
+		list_add(&rt_se->run_list, queue);
+	else
+		list_add_tail(&rt_se->run_list, queue);
+
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
@@ -532,6 +670,8 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 		rt_se->timeout = 0;
 
 	enqueue_rt_entity(rt_se);
+
+	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -540,6 +680,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 
 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se);
+
+	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
@@ -550,10 +692,12 @@ static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 {
 	struct rt_prio_array *array = &rt_rq->active;
-	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
-	if (on_rt_rq(rt_se))
-		list_move_tail(&rt_se->run_list, queue);
+	if (on_rt_rq(rt_se)) {
+		list_del_init(&rt_se->run_list);
+		list_add_tail(&rt_se->run_list,
+			      array->queue + rt_se_prio(rt_se));
+	}
 }
 
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)
@@ -616,8 +760,37 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
 {
-	if (p->prio < rq->curr->prio)
+	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
+		return;
+	}
+
+#ifdef CONFIG_SMP
+	/*
+	 * If:
+	 *
+	 * - the newly woken task is of equal priority to the current task
+	 * - the newly woken task is non-migratable while current is migratable
+	 * - current will be preempted on the next reschedule
+	 *
+	 * we should check to see if current can readily move to a different
+	 * cpu.  If so, we will reschedule to allow the push logic to try
+	 * to move current somewhere else, making room for our non-migratable
+	 * task.
+	 */
+	if((p->prio == rq->curr->prio)
+	   && p->rt.nr_cpus_allowed == 1
+	   && rq->curr->rt.nr_cpus_allowed != 1) {
+		cpumask_t mask;
+
+		if (cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
+			/*
+			 * There appears to be other cpus that can accept
+			 * current, so lets reschedule to try and push it away
+			 */
+			resched_task(rq->curr);
+	}
+#endif
 }
 
 static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
@@ -720,73 +893,6 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 
 static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
 
-static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
-{
-	int       lowest_prio = -1;
-	int       lowest_cpu  = -1;
-	int       count       = 0;
-	int       cpu;
-
-	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
-
-	/*
-	 * Scan each rq for the lowest prio.
-	 */
-	for_each_cpu_mask(cpu, *lowest_mask) {
-		struct rq *rq = cpu_rq(cpu);
-
-		/* We look for lowest RT prio or non-rt CPU */
-		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-			/*
-			 * if we already found a low RT queue
-			 * and now we found this non-rt queue
-			 * clear the mask and set our bit.
-			 * Otherwise just return the queue as is
-			 * and the count==1 will cause the algorithm
-			 * to use the first bit found.
-			 */
-			if (lowest_cpu != -1) {
-				cpus_clear(*lowest_mask);
-				cpu_set(rq->cpu, *lowest_mask);
-			}
-			return 1;
-		}
-
-		/* no locking for now */
-		if ((rq->rt.highest_prio > task->prio)
-		    && (rq->rt.highest_prio >= lowest_prio)) {
-			if (rq->rt.highest_prio > lowest_prio) {
-				/* new low - clear old data */
-				lowest_prio = rq->rt.highest_prio;
-				lowest_cpu = cpu;
-				count = 0;
-			}
-			count++;
-		} else
-			cpu_clear(cpu, *lowest_mask);
-	}
-
-	/*
-	 * Clear out all the set bits that represent
-	 * runqueues that were of higher prio than
-	 * the lowest_prio.
-	 */
-	if (lowest_cpu > 0) {
-		/*
-		 * Perhaps we could add another cpumask op to
-		 * zero out bits. Like cpu_zero_bits(cpumask, nrbits);
-		 * Then that could be optimized to use memset and such.
-		 */
-		for_each_cpu_mask(cpu, *lowest_mask) {
-			if (cpu >= lowest_cpu)
-				break;
-			cpu_clear(cpu, *lowest_mask);
-		}
-	}
-
-	return count;
-}
-
 static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 {
 	int first;
@@ -808,17 +914,12 @@ static int find_lowest_rq(struct task_struct *task)
 	cpumask_t *lowest_mask = &__get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
-	int count    = find_lowest_cpus(task, lowest_mask);
 
-	if (!count)
-		return -1; /* No targets found */
+	if (task->rt.nr_cpus_allowed == 1)
+		return -1; /* No other targets possible */
 
-	/*
-	 * There is no sense in performing an optimal search if only one
-	 * target is found.
-	 */
-	if (count == 1)
-		return first_cpu(*lowest_mask);
+	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
+		return -1; /* No targets found */
 
 	/*
 	 * At this point we have built a mask of cpus representing the
@@ -1163,17 +1264,25 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 }
 
 /* Assumes rq->lock is held */
-static void join_domain_rt(struct rq *rq)
+static void rq_online_rt(struct rq *rq)
 {
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
+
+	__enable_runtime(rq);
+
+	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
 }
 
 /* Assumes rq->lock is held */
-static void leave_domain_rt(struct rq *rq)
+static void rq_offline_rt(struct rq *rq)
 {
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
+
+	__disable_runtime(rq);
+
+	cpupri_set(&rq->rd->cpupri, rq->cpu, CPUPRI_INVALID);
 }
 
 /*
@@ -1336,8 +1445,8 @@ static const struct sched_class rt_sched_class = {
 	.load_balance		= load_balance_rt,
 	.move_one_task		= move_one_task_rt,
 	.set_cpus_allowed       = set_cpus_allowed_rt,
-	.join_domain            = join_domain_rt,
-	.leave_domain           = leave_domain_rt,
+	.rq_online              = rq_online_rt,
+	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_wake_up		= task_wake_up_rt,
@@ -1350,3 +1459,17 @@ static const struct sched_class rt_sched_class = {
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
 };
+
+#ifdef CONFIG_SCHED_DEBUG
+extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
+
+static void print_rt_stats(struct seq_file *m, int cpu)
+{
+	struct rt_rq *rt_rq;
+
+	rcu_read_lock();
+	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
+		print_rt_rq(m, cpu, rt_rq);
+	rcu_read_unlock();
+}
+#endif /* CONFIG_SCHED_DEBUG */
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 80179ef..8385d43 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -118,6 +118,13 @@ rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 	if (rq)
 		rq->rq_sched_info.cpu_time += delta;
 }
+
+static inline void
+rq_sched_info_dequeued(struct rq *rq, unsigned long long delta)
+{
+	if (rq)
+		rq->rq_sched_info.run_delay += delta;
+}
 # define schedstat_inc(rq, field)	do { (rq)->field++; } while (0)
 # define schedstat_add(rq, field, amt)	do { (rq)->field += (amt); } while (0)
 # define schedstat_set(var, val)	do { var = (val); } while (0)
@@ -126,6 +133,9 @@ static inline void
 rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 {}
 static inline void
+rq_sched_info_dequeued(struct rq *rq, unsigned long long delta)
+{}
+static inline void
 rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {}
 # define schedstat_inc(rq, field)	do { } while (0)
@@ -134,6 +144,11 @@ rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 #endif
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+static inline void sched_info_reset_dequeued(struct task_struct *t)
+{
+	t->sched_info.last_queued = 0;
+}
+
 /*
  * Called when a process is dequeued from the active array and given
  * the cpu.  We should note that with the exception of interactive
@@ -143,15 +158,22 @@ rq_sched_info_depart(struct rq *rq, unsigned long long delta)
  * active queue, thus delaying tasks in the expired queue from running;
  * see scheduler_tick()).
  *
- * This function is only called from sched_info_arrive(), rather than
- * dequeue_task(). Even though a task may be queued and dequeued multiple
- * times as it is shuffled about, we're really interested in knowing how
- * long it was from the *first* time it was queued to the time that it
- * finally hit a cpu.
+ * Though we are interested in knowing how long it was from the *first* time a
+ * task was queued to the time that it finally hit a cpu, we call this routine
+ * from dequeue_task() to account for possible rq->clock skew across cpus. The
+ * delta taken on each cpu would annul the skew.
  */
 static inline void sched_info_dequeued(struct task_struct *t)
 {
-	t->sched_info.last_queued = 0;
+	unsigned long long now = task_rq(t)->clock, delta = 0;
+
+	if (unlikely(sched_info_on()))
+		if (t->sched_info.last_queued)
+			delta = now - t->sched_info.last_queued;
+	sched_info_reset_dequeued(t);
+	t->sched_info.run_delay += delta;
+
+	rq_sched_info_dequeued(task_rq(t), delta);
 }
 
 /*
@@ -165,7 +187,7 @@ static void sched_info_arrive(struct task_struct *t)
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
-	sched_info_dequeued(t);
+	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
@@ -242,7 +264,9 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 		__sched_info_switch(prev, next);
 }
 #else
-#define sched_info_queued(t)		do { } while (0)
-#define sched_info_switch(t, next)	do { } while (0)
+#define sched_info_queued(t)			do { } while (0)
+#define sched_info_reset_dequeued(t)	do { } while (0)
+#define sched_info_dequeued(t)			do { } while (0)
+#define sched_info_switch(t, next)		do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2911665..fe8cdc8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -266,6 +266,14 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_shares_ratelimit",
+		.data		= &sysctl_sched_shares_ratelimit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b854a89..d63008b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -276,6 +276,7 @@ void tick_nohz_stop_sched_tick(void)
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 			rcu_enter_nohz();
+			sched_clock_tick_stop(cpu);
 		}
 
 		/*
@@ -375,6 +376,7 @@ void tick_nohz_restart_sched_tick(void)
 	select_nohz_load_balancer(0);
 	now = ktime_get();
 	tick_do_update_jiffies64(now);
+	sched_clock_tick_start(cpu);
 	cpu_clear(cpu, nohz_cpu_mask);
 
 	/*
