Return-Path: <linux-kernel-owner+w=401wt.eu-S934122AbZLFSCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbZLFSCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934079AbZLFSCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:02:51 -0500
Received: from www.tglx.de ([62.245.132.106]:33057 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934091AbZLFSC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:28 -0500
Message-Id: <20091206111957.491975360@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 05/23] locking: Rename __RAW_SPIN_LOCK_UNLOCKED to
	__ARCH_SPIN_LOCK_UNLOCKED
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=locking-rename-raw-lock-initializer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further name space cleanup. No functional change

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/spinlock_types.h    |    2 +-
 arch/arm/include/asm/spinlock_types.h      |    2 +-
 arch/blackfin/include/asm/spinlock_types.h |    2 +-
 arch/ia64/include/asm/spinlock_types.h     |    2 +-
 arch/m32r/include/asm/spinlock_types.h     |    2 +-
 arch/mips/include/asm/spinlock_types.h     |    2 +-
 arch/parisc/include/asm/spinlock_types.h   |    6 +++---
 arch/parisc/lib/bitops.c                   |    2 +-
 arch/powerpc/include/asm/spinlock_types.h  |    2 +-
 arch/powerpc/kernel/rtas.c                 |    2 +-
 arch/s390/include/asm/spinlock_types.h     |    2 +-
 arch/sh/include/asm/spinlock_types.h       |    2 +-
 arch/sparc/include/asm/spinlock_types.h    |    2 +-
 arch/x86/include/asm/spinlock_types.h      |    2 +-
 arch/x86/kernel/dumpstack.c                |    2 +-
 arch/x86/kernel/tsc_sync.c                 |    2 +-
 include/linux/spinlock_types.h             |    4 ++--
 include/linux/spinlock_types_up.h          |    4 ++--
 kernel/lockdep.c                           |    2 +-
 kernel/trace/ring_buffer.c                 |    2 +-
 kernel/trace/trace.c                       |   10 +++++-----
 kernel/trace/trace_clock.c                 |    2 +-
 kernel/trace/trace_sched_wakeup.c          |    2 +-
 kernel/trace/trace_stack.c                 |    2 +-
 lib/spinlock_debug.c                       |    2 +-
 25 files changed, 33 insertions(+), 33 deletions(-)

Index: linux-2.6-tip/arch/alpha/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/alpha/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/alpha/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile unsigned int lock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile unsigned int lock;
Index: linux-2.6-tip/arch/arm/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/arm/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile unsigned int lock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile unsigned int lock;
Index: linux-2.6-tip/arch/blackfin/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/blackfin/include/asm/spinlock_types.h
@@ -17,7 +17,7 @@ typedef struct {
 	volatile unsigned int lock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile unsigned int lock;
Index: linux-2.6-tip/arch/ia64/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/ia64/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile unsigned int lock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile unsigned int read_counter	: 31;
Index: linux-2.6-tip/arch/m32r/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/m32r/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/m32r/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile int slock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 1 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 1 }
 
 typedef struct {
 	volatile int lock;
Index: linux-2.6-tip/arch/mips/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/mips/include/asm/spinlock_types.h
@@ -14,7 +14,7 @@ typedef struct {
 	unsigned int lock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile unsigned int lock;
Index: linux-2.6-tip/arch/parisc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/parisc/include/asm/spinlock_types.h
@@ -4,10 +4,10 @@
 typedef struct {
 #ifdef CONFIG_PA20
 	volatile unsigned int slock;
-# define __RAW_SPIN_LOCK_UNLOCKED { 1 }
+# define __ARCH_SPIN_LOCK_UNLOCKED { 1 }
 #else
 	volatile unsigned int lock[4];
-# define __RAW_SPIN_LOCK_UNLOCKED	{ { 1, 1, 1, 1 } }
+# define __ARCH_SPIN_LOCK_UNLOCKED	{ { 1, 1, 1, 1 } }
 #endif
 } arch_spinlock_t;
 
@@ -16,6 +16,6 @@ typedef struct {
 	volatile int counter;
 } raw_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ __RAW_SPIN_LOCK_UNLOCKED, 0 }
+#define __RAW_RW_LOCK_UNLOCKED		{ __ARCH_SPIN_LOCK_UNLOCKED, 0 }
 
 #endif
Index: linux-2.6-tip/arch/parisc/lib/bitops.c
===================================================================
--- linux-2.6-tip.orig/arch/parisc/lib/bitops.c
+++ linux-2.6-tip/arch/parisc/lib/bitops.c
@@ -13,7 +13,7 @@
 
 #ifdef CONFIG_SMP
 arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
-	[0 ... (ATOMIC_HASH_SIZE-1)]  = __RAW_SPIN_LOCK_UNLOCKED
+	[0 ... (ATOMIC_HASH_SIZE-1)]  = __ARCH_SPIN_LOCK_UNLOCKED
 };
 #endif
 
Index: linux-2.6-tip/arch/powerpc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/powerpc/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile unsigned int slock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile signed int lock;
Index: linux-2.6-tip/arch/powerpc/kernel/rtas.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/rtas.c
+++ linux-2.6-tip/arch/powerpc/kernel/rtas.c
@@ -42,7 +42,7 @@
 #include <asm/mmu.h>
 
 struct rtas_t rtas = {
-	.lock = __RAW_SPIN_LOCK_UNLOCKED
+	.lock = __ARCH_SPIN_LOCK_UNLOCKED
 };
 EXPORT_SYMBOL(rtas);
 
Index: linux-2.6-tip/arch/s390/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/s390/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/s390/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile unsigned int owner_cpu;
 } __attribute__ ((aligned (4))) arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile unsigned int lock;
Index: linux-2.6-tip/arch/sh/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/sh/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/sh/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile unsigned int lock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED		{ 1 }
+#define __ARCH_SPIN_LOCK_UNLOCKED		{ 1 }
 
 typedef struct {
 	volatile unsigned int lock;
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	volatile unsigned char lock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	volatile unsigned int lock;
Index: linux-2.6-tip/arch/x86/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/x86/include/asm/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct arch_spinlock {
 	unsigned int slock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	unsigned int lock;
Index: linux-2.6-tip/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/dumpstack.c
+++ linux-2.6-tip/arch/x86/kernel/dumpstack.c
@@ -188,7 +188,7 @@ void dump_stack(void)
 }
 EXPORT_SYMBOL(dump_stack);
 
-static arch_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
 
Index: linux-2.6-tip/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/tsc_sync.c
+++ linux-2.6-tip/arch/x86/kernel/tsc_sync.c
@@ -33,7 +33,7 @@ static __cpuinitdata atomic_t stop_count
  * we want to have the fastest, inlined, non-debug version
  * of a critical section, to be able to prove TSC time-warps:
  */
-static __cpuinitdata arch_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static __cpuinitdata arch_spinlock_t sync_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 
 static __cpuinitdata cycles_t last_tsc;
 static __cpuinitdata cycles_t max_warp;
Index: linux-2.6-tip/include/linux/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_types.h
+++ linux-2.6-tip/include/linux/spinlock_types.h
@@ -43,14 +43,14 @@ typedef struct {
 
 #ifdef CONFIG_DEBUG_SPINLOCK
 # define __SPIN_LOCK_UNLOCKED(lockname)					\
-	(spinlock_t)	{	.raw_lock = __RAW_SPIN_LOCK_UNLOCKED,	\
+	(spinlock_t)	{	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
 				.magic = SPINLOCK_MAGIC,		\
 				.owner = SPINLOCK_OWNER_INIT,		\
 				.owner_cpu = -1,			\
 				SPIN_DEP_MAP_INIT(lockname) }
 #else
 # define __SPIN_LOCK_UNLOCKED(lockname) \
-	(spinlock_t)	{	.raw_lock = __RAW_SPIN_LOCK_UNLOCKED,	\
+	(spinlock_t)	{	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
 				SPIN_DEP_MAP_INIT(lockname) }
 #endif
 
Index: linux-2.6-tip/include/linux/spinlock_types_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_types_up.h
+++ linux-2.6-tip/include/linux/spinlock_types_up.h
@@ -18,13 +18,13 @@ typedef struct {
 	volatile unsigned int slock;
 } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED { 1 }
+#define __ARCH_SPIN_LOCK_UNLOCKED { 1 }
 
 #else
 
 typedef struct { } arch_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED { }
+#define __ARCH_SPIN_LOCK_UNLOCKED { }
 
 #endif
 
Index: linux-2.6-tip/kernel/lockdep.c
===================================================================
--- linux-2.6-tip.orig/kernel/lockdep.c
+++ linux-2.6-tip/kernel/lockdep.c
@@ -73,7 +73,7 @@ module_param(lock_stat, int, 0644);
  * to use a raw spinlock - we really dont want the spinlock
  * code to recurse back into the lockdep code...
  */
-static arch_spinlock_t lockdep_lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t lockdep_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 static int graph_lock(void)
 {
Index: linux-2.6-tip/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/ring_buffer.c
+++ linux-2.6-tip/kernel/trace/ring_buffer.c
@@ -998,7 +998,7 @@ rb_allocate_cpu_buffer(struct ring_buffe
 	cpu_buffer->buffer = buffer;
 	spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
-	cpu_buffer->lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
Index: linux-2.6-tip/kernel/trace/trace.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace.c
+++ linux-2.6-tip/kernel/trace/trace.c
@@ -501,7 +501,7 @@ static ssize_t trace_seq_to_buffer(struc
  * CONFIG_TRACER_MAX_TRACE.
  */
 static arch_spinlock_t ftrace_max_lock =
-	(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
@@ -802,7 +802,7 @@ static unsigned map_pid_to_cmdline[PID_M
 static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
 static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
 static int cmdline_idx;
-static arch_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 
 /* temporary disable recording */
 static atomic_t trace_record_cmdline_disabled __read_mostly;
@@ -1252,7 +1252,7 @@ ftrace_special(unsigned long arg1, unsig
 int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
 	static arch_spinlock_t trace_buf_lock =
-		(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	static u32 trace_buf[TRACE_BUF_SIZE];
 
 	struct ftrace_event_call *call = &event_bprint;
@@ -1334,7 +1334,7 @@ int trace_array_printk(struct trace_arra
 int trace_array_vprintk(struct trace_array *tr,
 			unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
+	static arch_spinlock_t trace_buf_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
 
 	struct ftrace_event_call *call = &event_print;
@@ -4269,7 +4269,7 @@ trace_printk_seq(struct trace_seq *s)
 static void __ftrace_dump(bool disable_tracing)
 {
 	static arch_spinlock_t ftrace_dump_lock =
-		(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
 	unsigned int old_userobj;
Index: linux-2.6-tip/kernel/trace/trace_clock.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_clock.c
+++ linux-2.6-tip/kernel/trace/trace_clock.c
@@ -74,7 +74,7 @@ static struct {
 	arch_spinlock_t lock;
 } trace_clock_struct ____cacheline_aligned_in_smp =
 	{
-		.lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED,
+		.lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED,
 	};
 
 u64 notrace trace_clock_global(void)
Index: linux-2.6-tip/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_sched_wakeup.c
+++ linux-2.6-tip/kernel/trace/trace_sched_wakeup.c
@@ -29,7 +29,7 @@ static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
 
 static arch_spinlock_t wakeup_lock =
-	(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 static void __wakeup_reset(struct trace_array *tr);
 
Index: linux-2.6-tip/kernel/trace/trace_stack.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_stack.c
+++ linux-2.6-tip/kernel/trace/trace_stack.c
@@ -28,7 +28,7 @@ static struct stack_trace max_stack_trac
 
 static unsigned long max_stack_size;
 static arch_spinlock_t max_stack_lock =
-	(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 static int stack_trace_disabled __read_mostly;
 static DEFINE_PER_CPU(int, trace_active);
Index: linux-2.6-tip/lib/spinlock_debug.c
===================================================================
--- linux-2.6-tip.orig/lib/spinlock_debug.c
+++ linux-2.6-tip/lib/spinlock_debug.c
@@ -23,7 +23,7 @@ void __spin_lock_init(spinlock_t *lock, 
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->raw_lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	lock->magic = SPINLOCK_MAGIC;
 	lock->owner = SPINLOCK_OWNER_INIT;
 	lock->owner_cpu = -1;


