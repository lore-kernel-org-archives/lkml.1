Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYJOVFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYJOVFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYJOVDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:03:13 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:1196 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYJOVDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:03:01 -0400
X-BigFish: VPS1(zzzzzzz32i67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 5,
X-WSS-ID: 0K8ST4E-01-4GL-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/8] oprofile: more whitespace fixes
Date: Wed, 15 Oct 2008 22:09:07 +0200
Message-ID: <1224101350-12877-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0878 (UTC) FILETIME=[5B3E23E0:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/alpha/oprofile/common.c          |    2 +-
 arch/ia64/oprofile/init.c             |    4 +-
 arch/ia64/oprofile/perfmon.c          |    4 +-
 arch/m32r/oprofile/init.c             |    2 +-
 arch/mips/oprofile/common.c           |    2 +-
 arch/mips/oprofile/op_impl.h          |    2 +-
 arch/mips/oprofile/op_model_rm9000.c  |    2 +-
 arch/parisc/oprofile/init.c           |    2 +-
 arch/powerpc/oprofile/op_model_cell.c |    2 +-
 arch/sparc/oprofile/init.c            |    2 +-
 arch/sparc64/oprofile/init.c          |    2 +-
 arch/x86/oprofile/backtrace.c         |    2 +-
 arch/x86/oprofile/op_model_amd.c      |    6 +-
 arch/x86/oprofile/op_x86_model.h      |    4 +-
 drivers/oprofile/cpu_buffer.c         |   22 +++++-----
 drivers/oprofile/cpu_buffer.h         |    6 +-
 drivers/oprofile/event_buffer.c       |   10 ++--
 drivers/oprofile/oprof.h              |    4 +-
 drivers/oprofile/oprofile_files.c     |   16 ++++----
 drivers/oprofile/oprofile_stats.c     |   10 ++--
 drivers/oprofile/oprofile_stats.h     |    2 +-
 drivers/oprofile/oprofilefs.c         |   72 ++++++++++++++++----------------
 drivers/oprofile/timer_int.c          |    2 +-
 23 files changed, 91 insertions(+), 91 deletions(-)

diff --git a/arch/alpha/oprofile/common.c b/arch/alpha/oprofile/common.c
index 7c3d5ec..bd8ac53 100644
--- a/arch/alpha/oprofile/common.c
+++ b/arch/alpha/oprofile/common.c
@@ -106,7 +106,7 @@ op_axp_stop(void)
 }
 
 static int
-op_axp_create_files(struct super_block * sb, struct dentry * root)
+op_axp_create_files(struct super_block *sb, struct dentry *root)
 {
 	int i;
 
diff --git a/arch/ia64/oprofile/init.c b/arch/ia64/oprofile/init.c
index 125a602..31b545c 100644
--- a/arch/ia64/oprofile/init.c
+++ b/arch/ia64/oprofile/init.c
@@ -12,11 +12,11 @@
 #include <linux/init.h>
 #include <linux/errno.h>
  
-extern int perfmon_init(struct oprofile_operations * ops);
+extern int perfmon_init(struct oprofile_operations *ops);
 extern void perfmon_exit(void);
 extern void ia64_backtrace(struct pt_regs * const regs, unsigned int depth);
 
-int __init oprofile_arch_init(struct oprofile_operations * ops)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	int ret = -ENODEV;
 
diff --git a/arch/ia64/oprofile/perfmon.c b/arch/ia64/oprofile/perfmon.c
index bc41dd3..192d3e8 100644
--- a/arch/ia64/oprofile/perfmon.c
+++ b/arch/ia64/oprofile/perfmon.c
@@ -56,7 +56,7 @@ static pfm_buffer_fmt_t oprofile_fmt = {
 };
 
 
-static char * get_cpu_type(void)
+static char *get_cpu_type(void)
 {
 	__u8 family = local_cpu_data->family;
 
@@ -75,7 +75,7 @@ static char * get_cpu_type(void)
 
 static int using_perfmon;
 
-int perfmon_init(struct oprofile_operations * ops)
+int perfmon_init(struct oprofile_operations *ops)
 {
 	int ret = pfm_register_buffer_fmt(&oprofile_fmt);
 	if (ret)
diff --git a/arch/m32r/oprofile/init.c b/arch/m32r/oprofile/init.c
index b7773e4..fa56860 100644
--- a/arch/m32r/oprofile/init.c
+++ b/arch/m32r/oprofile/init.c
@@ -12,7 +12,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 
-int __init oprofile_arch_init(struct oprofile_operations * ops)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	return -ENODEV;
 }
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index dd2fbd6..3bf3354 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -32,7 +32,7 @@ static int op_mips_setup(void)
         return 0;
 }
 
-static int op_mips_create_files(struct super_block * sb, struct dentry * root)
+static int op_mips_create_files(struct super_block *sb, struct dentry *root)
 {
 	int i;
 
diff --git a/arch/mips/oprofile/op_impl.h b/arch/mips/oprofile/op_impl.h
index 2bfc17c..f04b54f 100644
--- a/arch/mips/oprofile/op_impl.h
+++ b/arch/mips/oprofile/op_impl.h
@@ -27,7 +27,7 @@ struct op_counter_config {
 /* Per-architecture configury and hooks.  */
 struct op_mips_model {
 	void (*reg_setup) (struct op_counter_config *);
-	void (*cpu_setup) (void * dummy);
+	void (*cpu_setup) (void *dummy);
 	int (*init)(void);
 	void (*exit)(void);
 	void (*cpu_start)(void *args);
diff --git a/arch/mips/oprofile/op_model_rm9000.c b/arch/mips/oprofile/op_model_rm9000.c
index a45d320..3aa8138 100644
--- a/arch/mips/oprofile/op_model_rm9000.c
+++ b/arch/mips/oprofile/op_model_rm9000.c
@@ -80,7 +80,7 @@ static void rm9000_cpu_stop(void *args)
 	write_c0_perfcontrol(0);
 }
 
-static irqreturn_t rm9000_perfcount_handler(int irq, void * dev_id)
+static irqreturn_t rm9000_perfcount_handler(int irq, void *dev_id)
 {
 	unsigned int control = read_c0_perfcontrol();
 	struct pt_regs *regs = get_irq_regs();
diff --git a/arch/parisc/oprofile/init.c b/arch/parisc/oprofile/init.c
index 113f513..026cba2 100644
--- a/arch/parisc/oprofile/init.c
+++ b/arch/parisc/oprofile/init.c
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/oprofile.h>
 
-int __init oprofile_arch_init(struct oprofile_operations * ops)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	return -ENODEV;
 }
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 5ff4de3..35141a8 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -404,7 +404,7 @@ set_count_mode(u32 kernel, u32 user)
 	}
 }
 
-static inline void enable_ctr(u32 cpu, u32 ctr, u32 * pm07_cntrl)
+static inline void enable_ctr(u32 cpu, u32 ctr, u32 *pm07_cntrl)
 {
 
 	pm07_cntrl[ctr] |= CBE_PM_CTR_ENABLE;
diff --git a/arch/sparc/oprofile/init.c b/arch/sparc/oprofile/init.c
index 9ab815b..17bb603 100644
--- a/arch/sparc/oprofile/init.c
+++ b/arch/sparc/oprofile/init.c
@@ -12,7 +12,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
  
-int __init oprofile_arch_init(struct oprofile_operations * ops)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	return -ENODEV;
 }
diff --git a/arch/sparc64/oprofile/init.c b/arch/sparc64/oprofile/init.c
index 9ab815b..17bb603 100644
--- a/arch/sparc64/oprofile/init.c
+++ b/arch/sparc64/oprofile/init.c
@@ -12,7 +12,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
  
-int __init oprofile_arch_init(struct oprofile_operations * ops)
+int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	return -ENODEV;
 }
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index e2095cb..36e3241 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -53,7 +53,7 @@ struct frame_head {
 } __attribute__((packed));
 
 static struct frame_head *
-dump_user_backtrace(struct frame_head * head)
+dump_user_backtrace(struct frame_head *head)
 {
 	struct frame_head bufhead[2];
 
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index b9a810b..a2e83af 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -69,7 +69,7 @@ static unsigned long reset_value[NUM_COUNTERS];
    data. Should then be added to linux/oprofile.h. */
 extern void
 oprofile_add_ibs_sample(struct pt_regs *const regs,
-			unsigned int * const ibs_sample, int ibs_code);
+			unsigned int *const ibs_sample, int ibs_code);
 
 struct ibs_fetch_sample {
 	/* MSRC001_1031 IBS Fetch Linear Address Register */
@@ -469,9 +469,9 @@ static void clear_ibs_nmi(void)
 		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
-static int (*create_arch_files)(struct super_block * sb, struct dentry * root);
+static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
 
-static int setup_ibs_files(struct super_block * sb, struct dentry * root)
+static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 {
 	struct dentry *dir;
 	int ret = 0;
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 05a0261..24ccdeb 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -22,8 +22,8 @@ struct op_msr {
 };
 
 struct op_msrs {
-	struct op_msr * counters;
-	struct op_msr * controls;
+	struct op_msr *counters;
+	struct op_msr *controls;
 };
 
 struct pt_regs;
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index d6c6827..b47ce03 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -112,7 +112,7 @@ void end_cpu_work(void)
 }
 
 /* Resets the cpu buffer to a sane state. */
-void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf)
+void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf)
 {
 	/* reset these to invalid values; the next sample
 	 * collected will populate the buffer with proper
@@ -123,7 +123,7 @@ void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf)
 }
 
 /* compute number of available slots in cpu_buffer queue */
-static unsigned long nr_available_slots(struct oprofile_cpu_buffer const * b)
+static unsigned long nr_available_slots(struct oprofile_cpu_buffer const *b)
 {
 	unsigned long head = b->head_pos;
 	unsigned long tail = b->tail_pos;
@@ -134,7 +134,7 @@ static unsigned long nr_available_slots(struct oprofile_cpu_buffer const * b)
 	return tail + (b->buffer_size - head) - 1;
 }
 
-static void increment_head(struct oprofile_cpu_buffer * b)
+static void increment_head(struct oprofile_cpu_buffer *b)
 {
 	unsigned long new_head = b->head_pos + 1;
 
@@ -149,17 +149,17 @@ static void increment_head(struct oprofile_cpu_buffer * b)
 }
 
 static inline void
-add_sample(struct oprofile_cpu_buffer * cpu_buf,
+add_sample(struct oprofile_cpu_buffer *cpu_buf,
            unsigned long pc, unsigned long event)
 {
-	struct op_sample * entry = &cpu_buf->buffer[cpu_buf->head_pos];
+	struct op_sample *entry = &cpu_buf->buffer[cpu_buf->head_pos];
 	entry->eip = pc;
 	entry->event = event;
 	increment_head(cpu_buf);
 }
 
 static inline void
-add_code(struct oprofile_cpu_buffer * buffer, unsigned long value)
+add_code(struct oprofile_cpu_buffer *buffer, unsigned long value)
 {
 	add_sample(buffer, ESCAPE_CODE, value);
 }
@@ -173,10 +173,10 @@ add_code(struct oprofile_cpu_buffer * buffer, unsigned long value)
  * pc. We tag this in the buffer by generating kernel enter/exit
  * events whenever is_kernel changes
  */
-static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
+static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 		      int is_kernel, unsigned long event)
 {
-	struct task_struct * task;
+	struct task_struct *task;
 
 	cpu_buf->sample_received++;
 
@@ -222,7 +222,7 @@ static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 	return 1;
 }
 
-static void oprofile_end_trace(struct oprofile_cpu_buffer * cpu_buf)
+static void oprofile_end_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
 	cpu_buf->tracing = 0;
 }
@@ -260,7 +260,7 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 #define MAX_IBS_SAMPLE_SIZE 14
 
 void oprofile_add_ibs_sample(struct pt_regs *const regs,
-			     unsigned int * const ibs_sample, int ibs_code)
+			     unsigned int *const ibs_sample, int ibs_code)
 {
 	int is_kernel = !user_mode(regs);
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
@@ -345,7 +345,7 @@ void oprofile_add_trace(unsigned long pc)
  */
 static void wq_sync_buffer(struct work_struct *work)
 {
-	struct oprofile_cpu_buffer * b =
+	struct oprofile_cpu_buffer *b =
 		container_of(work, struct oprofile_cpu_buffer, work.work);
 	if (b->cpu != smp_processor_id()) {
 		printk(KERN_DEBUG "WQ on CPU%d, prefer CPU%d\n",
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 9c44d00..9bc6bb2 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -36,10 +36,10 @@ struct oprofile_cpu_buffer {
 	volatile unsigned long head_pos;
 	volatile unsigned long tail_pos;
 	unsigned long buffer_size;
-	struct task_struct * last_task;
+	struct task_struct *last_task;
 	int last_is_kernel;
 	int tracing;
-	struct op_sample * buffer;
+	struct op_sample *buffer;
 	unsigned long sample_received;
 	unsigned long sample_lost_overflow;
 	unsigned long backtrace_aborted;
@@ -50,7 +50,7 @@ struct oprofile_cpu_buffer {
 
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
-void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
+void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf);
 
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index 8d692a5..c9329f4 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -28,7 +28,7 @@ DEFINE_MUTEX(buffer_mutex);
  
 static unsigned long buffer_opened;
 static DECLARE_WAIT_QUEUE_HEAD(buffer_wait);
-static unsigned long * event_buffer;
+static unsigned long *event_buffer;
 static unsigned long buffer_size;
 static unsigned long buffer_watershed;
 static size_t buffer_pos;
@@ -98,7 +98,7 @@ void free_event_buffer(void)
 }
 
  
-static int event_buffer_open(struct inode * inode, struct file * file)
+static int event_buffer_open(struct inode *inode, struct file *file)
 {
 	int err = -EPERM;
 
@@ -134,7 +134,7 @@ out:
 }
 
 
-static int event_buffer_release(struct inode * inode, struct file * file)
+static int event_buffer_release(struct inode *inode, struct file *file)
 {
 	oprofile_stop();
 	oprofile_shutdown();
@@ -146,8 +146,8 @@ static int event_buffer_release(struct inode * inode, struct file * file)
 }
 
 
-static ssize_t event_buffer_read(struct file * file, char __user * buf,
-				 size_t count, loff_t * offset)
+static ssize_t event_buffer_read(struct file *file, char __user *buf,
+				 size_t count, loff_t *offset)
 {
 	int retval = -EINVAL;
 	size_t const max = buffer_size * sizeof(unsigned long);
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index 1832365..7a44ddb 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -31,8 +31,8 @@ extern unsigned long backtrace_depth;
 struct super_block;
 struct dentry;
 
-void oprofile_create_files(struct super_block * sb, struct dentry * root);
-void oprofile_timer_init(struct oprofile_operations * ops);
+void oprofile_create_files(struct super_block *sb, struct dentry *root);
+void oprofile_timer_init(struct oprofile_operations *ops);
 
 int oprofile_set_backtrace(unsigned long depth);
  
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index ef953ba..241804a 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -18,13 +18,13 @@ unsigned long fs_buffer_size = 131072;
 unsigned long fs_cpu_buffer_size = 8192;
 unsigned long fs_buffer_watershed = 32768; /* FIXME: tune */
 
-static ssize_t depth_read(struct file * file, char __user * buf, size_t count, loff_t * offset)
+static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
 	return oprofilefs_ulong_to_user(backtrace_depth, buf, count, offset);
 }
 
 
-static ssize_t depth_write(struct file * file, char const __user * buf, size_t count, loff_t * offset)
+static ssize_t depth_write(struct file *file, char const __user *buf, size_t count, loff_t *offset)
 {
 	unsigned long val;
 	int retval;
@@ -50,7 +50,7 @@ static const struct file_operations depth_fops = {
 };
 
  
-static ssize_t pointer_size_read(struct file * file, char __user * buf, size_t count, loff_t * offset)
+static ssize_t pointer_size_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
 	return oprofilefs_ulong_to_user(sizeof(void *), buf, count, offset);
 }
@@ -61,7 +61,7 @@ static const struct file_operations pointer_size_fops = {
 };
 
 
-static ssize_t cpu_type_read(struct file * file, char __user * buf, size_t count, loff_t * offset)
+static ssize_t cpu_type_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
 	return oprofilefs_str_to_user(oprofile_ops.cpu_type, buf, count, offset);
 }
@@ -72,13 +72,13 @@ static const struct file_operations cpu_type_fops = {
 };
  
  
-static ssize_t enable_read(struct file * file, char __user * buf, size_t count, loff_t * offset)
+static ssize_t enable_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
 	return oprofilefs_ulong_to_user(oprofile_started, buf, count, offset);
 }
 
 
-static ssize_t enable_write(struct file * file, char const __user * buf, size_t count, loff_t * offset)
+static ssize_t enable_write(struct file *file, char const __user *buf, size_t count, loff_t *offset)
 {
 	unsigned long val;
 	int retval;
@@ -107,7 +107,7 @@ static const struct file_operations enable_fops = {
 };
 
 
-static ssize_t dump_write(struct file * file, char const __user * buf, size_t count, loff_t * offset)
+static ssize_t dump_write(struct file *file, char const __user *buf, size_t count, loff_t *offset)
 {
 	wake_up_buffer_waiter();
 	return count;
@@ -118,7 +118,7 @@ static const struct file_operations dump_fops = {
 	.write		= dump_write,
 };
  
-void oprofile_create_files(struct super_block * sb, struct dentry * root)
+void oprofile_create_files(struct super_block *sb, struct dentry *root)
 {
 	oprofilefs_create_file(sb, root, "enable", &enable_fops);
 	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index f99b28e..e0c4549 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -19,7 +19,7 @@ struct oprofile_stat_struct oprofile_stats;
  
 void oprofile_reset_stats(void)
 {
-	struct oprofile_cpu_buffer * cpu_buf; 
+	struct oprofile_cpu_buffer *cpu_buf;
 	int i;
  
 	for_each_possible_cpu(i) {
@@ -36,11 +36,11 @@ void oprofile_reset_stats(void)
 }
 
 
-void oprofile_create_stats_files(struct super_block * sb, struct dentry * root)
+void oprofile_create_stats_files(struct super_block *sb, struct dentry *root)
 {
-	struct oprofile_cpu_buffer * cpu_buf;
-	struct dentry * cpudir;
-	struct dentry * dir;
+	struct oprofile_cpu_buffer *cpu_buf;
+	struct dentry *cpudir;
+	struct dentry *dir;
 	char buf[10];
 	int i;
 
diff --git a/drivers/oprofile/oprofile_stats.h b/drivers/oprofile/oprofile_stats.h
index 6d755a6..54e59c2 100644
--- a/drivers/oprofile/oprofile_stats.h
+++ b/drivers/oprofile/oprofile_stats.h
@@ -28,6 +28,6 @@ struct super_block;
 struct dentry;
  
 /* create the stats/ dir */
-void oprofile_create_stats_files(struct super_block * sb, struct dentry * root);
+void oprofile_create_stats_files(struct super_block *sb, struct dentry *root);
 
 #endif /* OPROFILE_STATS_H */
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 8543cb2..a275a3a 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -23,9 +23,9 @@
 
 DEFINE_SPINLOCK(oprofilefs_lock);
 
-static struct inode * oprofilefs_get_inode(struct super_block * sb, int mode)
+static struct inode *oprofilefs_get_inode(struct super_block *sb, int mode)
 {
-	struct inode * inode = new_inode(sb);
+	struct inode *inode = new_inode(sb);
 
 	if (inode) {
 		inode->i_mode = mode;
@@ -44,7 +44,7 @@ static struct super_operations s_ops = {
 };
 
 
-ssize_t oprofilefs_str_to_user(char const * str, char __user * buf, size_t count, loff_t * offset)
+ssize_t oprofilefs_str_to_user(char const *str, char __user *buf, size_t count, loff_t *offset)
 {
 	return simple_read_from_buffer(buf, count, offset, str, strlen(str));
 }
@@ -52,7 +52,7 @@ ssize_t oprofilefs_str_to_user(char const * str, char __user * buf, size_t count
 
 #define TMPBUFSIZE 50
 
-ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user * buf, size_t count, loff_t * offset)
+ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user *buf, size_t count, loff_t *offset)
 {
 	char tmpbuf[TMPBUFSIZE];
 	size_t maxlen = snprintf(tmpbuf, TMPBUFSIZE, "%lu\n", val);
@@ -62,7 +62,7 @@ ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user * buf, size_t co
 }
 
 
-int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, size_t count)
+int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_t count)
 {
 	char tmpbuf[TMPBUFSIZE];
 	unsigned long flags;
@@ -85,16 +85,16 @@ int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, siz
 }
 
 
-static ssize_t ulong_read_file(struct file * file, char __user * buf, size_t count, loff_t * offset)
+static ssize_t ulong_read_file(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
-	unsigned long * val = file->private_data;
+	unsigned long *val = file->private_data;
 	return oprofilefs_ulong_to_user(*val, buf, count, offset);
 }
 
 
-static ssize_t ulong_write_file(struct file * file, char const __user * buf, size_t count, loff_t * offset)
+static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_t count, loff_t *offset)
 {
-	unsigned long * value = file->private_data;
+	unsigned long *value = file->private_data;
 	int retval;
 
 	if (*offset)
@@ -108,7 +108,7 @@ static ssize_t ulong_write_file(struct file * file, char const __user * buf, siz
 }
 
 
-static int default_open(struct inode * inode, struct file * filp)
+static int default_open(struct inode *inode, struct file *filp)
 {
 	if (inode->i_private)
 		filp->private_data = inode->i_private;
@@ -129,12 +129,12 @@ static const struct file_operations ulong_ro_fops = {
 };
 
 
-static struct dentry * __oprofilefs_create_file(struct super_block * sb,
-	struct dentry * root, char const * name, const struct file_operations * fops,
+static struct dentry *__oprofilefs_create_file(struct super_block *sb,
+	struct dentry *root, char const *name, const struct file_operations *fops,
 	int perm)
 {
-	struct dentry * dentry;
-	struct inode * inode;
+	struct dentry *dentry;
+	struct inode *inode;
 
 	dentry = d_alloc_name(root, name);
 	if (!dentry)
@@ -150,10 +150,10 @@ static struct dentry * __oprofilefs_create_file(struct super_block * sb,
 }
 
 
-int oprofilefs_create_ulong(struct super_block * sb, struct dentry * root,
-	char const * name, unsigned long * val)
+int oprofilefs_create_ulong(struct super_block *sb, struct dentry *root,
+	char const *name, unsigned long *val)
 {
-	struct dentry * d = __oprofilefs_create_file(sb, root, name,
+	struct dentry *d = __oprofilefs_create_file(sb, root, name,
 						     &ulong_fops, 0644);
 	if (!d)
 		return -EFAULT;
@@ -163,10 +163,10 @@ int oprofilefs_create_ulong(struct super_block * sb, struct dentry * root,
 }
 
 
-int oprofilefs_create_ro_ulong(struct super_block * sb, struct dentry * root,
-	char const * name, unsigned long * val)
+int oprofilefs_create_ro_ulong(struct super_block *sb, struct dentry *root,
+	char const *name, unsigned long *val)
 {
-	struct dentry * d = __oprofilefs_create_file(sb, root, name,
+	struct dentry *d = __oprofilefs_create_file(sb, root, name,
 						     &ulong_ro_fops, 0444);
 	if (!d)
 		return -EFAULT;
@@ -176,9 +176,9 @@ int oprofilefs_create_ro_ulong(struct super_block * sb, struct dentry * root,
 }
 
 
-static ssize_t atomic_read_file(struct file * file, char __user * buf, size_t count, loff_t * offset)
+static ssize_t atomic_read_file(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
-	atomic_t * val = file->private_data;
+	atomic_t *val = file->private_data;
 	return oprofilefs_ulong_to_user(atomic_read(val), buf, count, offset);
 }
  
@@ -189,10 +189,10 @@ static const struct file_operations atomic_ro_fops = {
 };
  
 
-int oprofilefs_create_ro_atomic(struct super_block * sb, struct dentry * root,
-	char const * name, atomic_t * val)
+int oprofilefs_create_ro_atomic(struct super_block *sb, struct dentry *root,
+	char const *name, atomic_t *val)
 {
-	struct dentry * d = __oprofilefs_create_file(sb, root, name,
+	struct dentry *d = __oprofilefs_create_file(sb, root, name,
 						     &atomic_ro_fops, 0444);
 	if (!d)
 		return -EFAULT;
@@ -202,8 +202,8 @@ int oprofilefs_create_ro_atomic(struct super_block * sb, struct dentry * root,
 }
 
  
-int oprofilefs_create_file(struct super_block * sb, struct dentry * root,
-	char const * name, const struct file_operations * fops)
+int oprofilefs_create_file(struct super_block *sb, struct dentry *root,
+	char const *name, const struct file_operations *fops)
 {
 	if (!__oprofilefs_create_file(sb, root, name, fops, 0644))
 		return -EFAULT;
@@ -211,8 +211,8 @@ int oprofilefs_create_file(struct super_block * sb, struct dentry * root,
 }
 
 
-int oprofilefs_create_file_perm(struct super_block * sb, struct dentry * root,
-	char const * name, const struct file_operations * fops, int perm)
+int oprofilefs_create_file_perm(struct super_block *sb, struct dentry *root,
+	char const *name, const struct file_operations *fops, int perm)
 {
 	if (!__oprofilefs_create_file(sb, root, name, fops, perm))
 		return -EFAULT;
@@ -220,11 +220,11 @@ int oprofilefs_create_file_perm(struct super_block * sb, struct dentry * root,
 }
 
 
-struct dentry * oprofilefs_mkdir(struct super_block * sb,
-	struct dentry * root, char const * name)
+struct dentry *oprofilefs_mkdir(struct super_block *sb,
+	struct dentry *root, char const *name)
 {
-	struct dentry * dentry;
-	struct inode * inode;
+	struct dentry *dentry;
+	struct inode *inode;
 
 	dentry = d_alloc_name(root, name);
 	if (!dentry)
@@ -241,10 +241,10 @@ struct dentry * oprofilefs_mkdir(struct super_block * sb,
 }
 
 
-static int oprofilefs_fill_super(struct super_block * sb, void * data, int silent)
+static int oprofilefs_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct inode * root_inode;
-	struct dentry * root_dentry;
+	struct inode *root_inode;
+	struct dentry *root_dentry;
 
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 710a45f..7258b14 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -35,7 +35,7 @@ static void timer_stop(void)
 }
 
 
-void __init oprofile_timer_init(struct oprofile_operations * ops)
+void __init oprofile_timer_init(struct oprofile_operations *ops)
 {
 	ops->create_files = NULL;
 	ops->setup = NULL;
-- 
1.6.0.1


