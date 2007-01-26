Return-Path: <linux-kernel-owner+w=401wt.eu-S1030785AbXAZQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030785AbXAZQqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030787AbXAZQqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:46:43 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58616 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030642AbXAZQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:46:36 -0500
Date: Fri, 26 Jan 2007 17:46:31 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Get rid of a lot of sparse warnings.
Message-ID: <20070126164631.GB11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Get rid of a lot of sparse warnings.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/appldata/appldata_base.c    |    2 -
 arch/s390/appldata/appldata_mem.c     |    2 -
 arch/s390/appldata/appldata_net_sum.c |    2 -
 arch/s390/crypto/aes_s390.c           |    6 ++---
 arch/s390/crypto/des_check_key.c      |    1 
 arch/s390/kernel/compat_exec_domain.c |    5 +---
 arch/s390/kernel/compat_linux.c       |   18 +++++++++--------
 arch/s390/kernel/compat_signal.c      |    6 ++---
 arch/s390/kernel/crash.c              |    1 
 arch/s390/kernel/debug.c              |   18 +++++++----------
 arch/s390/kernel/ebcdic.c             |    1 
 arch/s390/kernel/kprobes.c            |    3 +-
 arch/s390/kernel/machine_kexec.c      |    1 
 arch/s390/kernel/module.c             |    1 
 arch/s390/kernel/ptrace.c             |   36 +++++++++++++++++-----------------
 arch/s390/kernel/setup.c              |    7 +-----
 arch/s390/kernel/smp.c                |   19 ++++-------------
 arch/s390/kernel/time.c               |    4 ---
 arch/s390/kernel/traps.c              |   13 +++++-------
 arch/s390/kernel/vtime.c              |    2 -
 arch/s390/lib/uaccess.h               |   23 +++++++++++++++++++++
 arch/s390/lib/uaccess_mvcos.c         |   27 ++++++++++---------------
 arch/s390/lib/uaccess_pt.c            |    1 
 arch/s390/lib/uaccess_std.c           |   23 +++++++++++----------
 arch/s390/mm/cmm.c                    |    2 -
 arch/s390/mm/fault.c                  |    5 +---
 arch/s390/mm/init.c                   |    3 --
 drivers/s390/block/dasd.c             |    2 -
 drivers/s390/block/dasd_diag.c        |    4 +--
 drivers/s390/block/dasd_eckd.c        |    2 -
 drivers/s390/block/dasd_genhd.c       |    2 -
 drivers/s390/block/dasd_proc.c        |    2 -
 drivers/s390/char/con3215.c           |    2 -
 drivers/s390/char/con3270.c           |    3 --
 drivers/s390/char/defkeymap.c         |    2 +
 drivers/s390/char/fs3270.c            |    4 +--
 drivers/s390/char/keyboard.c          |    2 +
 drivers/s390/char/raw3270.c           |    4 +--
 drivers/s390/char/sclp_tty.c          |    2 -
 drivers/s390/char/sclp_vt220.c        |    2 -
 drivers/s390/char/tape_char.c         |    8 +++----
 drivers/s390/char/tty3270.c           |   13 ++++--------
 drivers/s390/char/vmlogrdr.c          |    5 +---
 drivers/s390/cio/blacklist.c          |    2 -
 drivers/s390/cio/chsc.h               |    3 ++
 drivers/s390/cio/css.c                |    5 ----
 drivers/s390/cio/css.h                |    2 +
 drivers/s390/cio/device.c             |    1 
 drivers/s390/cio/device.h             |    2 +
 drivers/s390/cio/device_fsm.c         |    2 -
 drivers/s390/cio/qdio.c               |    3 --
 drivers/s390/crypto/zcrypt_api.c      |    4 +--
 drivers/s390/crypto/zcrypt_pcixcc.c   |    3 +-
 drivers/s390/net/claw.c               |    2 -
 drivers/s390/net/cu3088.c             |    2 -
 drivers/s390/net/lcs.c                |    6 ++---
 drivers/s390/net/netiucv.c            |    4 +--
 drivers/s390/net/qeth_sys.c           |    2 -
 drivers/s390/s390mach.c               |   14 ++++---------
 drivers/s390/scsi/zfcp_dbf.c          |    6 ++---
 drivers/s390/scsi/zfcp_erp.c          |    7 ++----
 drivers/s390/scsi/zfcp_ext.h          |    4 +--
 drivers/s390/scsi/zfcp_scsi.c         |   18 ++++++++---------
 include/asm-s390/kdebug.h             |    3 +-
 include/asm-s390/pgtable.h            |    1 
 include/asm-s390/setup.h              |    3 ++
 include/asm-s390/smp.h                |    4 +++
 include/asm-s390/timer.h              |    3 ++
 include/asm-s390/timex.h              |    2 +
 69 files changed, 210 insertions(+), 189 deletions(-)

diff -urpN linux-2.6/arch/s390/appldata/appldata_base.c linux-2.6-patched/arch/s390/appldata/appldata_base.c
--- linux-2.6/arch/s390/appldata/appldata_base.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/appldata/appldata_base.c	2007-01-26 17:27:46.000000000 +0100
@@ -81,7 +81,7 @@ static struct ctl_table appldata_dir_tab
 /*
  * Timer
  */
-DEFINE_PER_CPU(struct vtimer_list, appldata_timer);
+static DEFINE_PER_CPU(struct vtimer_list, appldata_timer);
 static atomic_t appldata_expire_count = ATOMIC_INIT(0);
 
 static DEFINE_SPINLOCK(appldata_timer_lock);
diff -urpN linux-2.6/arch/s390/appldata/appldata_mem.c linux-2.6-patched/arch/s390/appldata/appldata_mem.c
--- linux-2.6/arch/s390/appldata/appldata_mem.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/appldata/appldata_mem.c	2007-01-26 17:27:46.000000000 +0100
@@ -36,7 +36,7 @@
  * book:
  * http://oss.software.ibm.com/developerworks/opensource/linux390/index.shtml
  */
-struct appldata_mem_data {
+static struct appldata_mem_data {
 	u64 timestamp;
 	u32 sync_count_1;       /* after VM collected the record data, */
 	u32 sync_count_2;	/* sync_count_1 and sync_count_2 should be the
diff -urpN linux-2.6/arch/s390/appldata/appldata_net_sum.c linux-2.6-patched/arch/s390/appldata/appldata_net_sum.c
--- linux-2.6/arch/s390/appldata/appldata_net_sum.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/appldata/appldata_net_sum.c	2007-01-26 17:27:46.000000000 +0100
@@ -34,7 +34,7 @@
  * book:
  * http://oss.software.ibm.com/developerworks/opensource/linux390/index.shtml
  */
-struct appldata_net_sum_data {
+static struct appldata_net_sum_data {
 	u64 timestamp;
 	u32 sync_count_1;	/* after VM collected the record data, */
 	u32 sync_count_2;	/* sync_count_1 and sync_count_2 should be the
diff -urpN linux-2.6/arch/s390/crypto/aes_s390.c linux-2.6-patched/arch/s390/crypto/aes_s390.c
--- linux-2.6/arch/s390/crypto/aes_s390.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/aes_s390.c	2007-01-26 17:27:46.000000000 +0100
@@ -27,9 +27,9 @@
 /* data block size for all key lengths */
 #define AES_BLOCK_SIZE		16
 
-int has_aes_128 = 0;
-int has_aes_192 = 0;
-int has_aes_256 = 0;
+static int has_aes_128 = 0;
+static int has_aes_192 = 0;
+static int has_aes_256 = 0;
 
 struct s390_aes_ctx {
 	u8 iv[AES_BLOCK_SIZE];
diff -urpN linux-2.6/arch/s390/crypto/des_check_key.c linux-2.6-patched/arch/s390/crypto/des_check_key.c
--- linux-2.6/arch/s390/crypto/des_check_key.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/crypto/des_check_key.c	2007-01-26 17:27:46.000000000 +0100
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/crypto.h>
+#include "crypto_des.h"
 
 #define ROR(d,c,o)	((d) = (d) >> (c) | (d) << (o))
 
diff -urpN linux-2.6/arch/s390/kernel/compat_exec_domain.c linux-2.6-patched/arch/s390/kernel/compat_exec_domain.c
--- linux-2.6/arch/s390/kernel/compat_exec_domain.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/compat_exec_domain.c	2007-01-26 17:27:46.000000000 +0100
@@ -12,10 +12,9 @@
 #include <linux/personality.h>
 #include <linux/sched.h>
 
-struct exec_domain s390_exec_domain;
+static struct exec_domain s390_exec_domain;
 
-static int __init
-s390_init (void)
+static int __init s390_init (void)
 {
 	s390_exec_domain.name = "Linux/s390";
 	s390_exec_domain.handler = NULL;
diff -urpN linux-2.6/arch/s390/kernel/compat_linux.c linux-2.6-patched/arch/s390/kernel/compat_linux.c
--- linux-2.6/arch/s390/kernel/compat_linux.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/compat_linux.c	2007-01-26 17:27:46.000000000 +0100
@@ -416,7 +416,7 @@ asmlinkage long sys32_sysinfo(struct sys
 	mm_segment_t old_fs = get_fs ();
 	
 	set_fs (KERNEL_DS);
-	ret = sys_sysinfo((struct sysinfo __user *) &s);
+	ret = sys_sysinfo((struct sysinfo __force __user *) &s);
 	set_fs (old_fs);
 	err = put_user (s.uptime, &info->uptime);
 	err |= __put_user (s.loads[0], &info->loads[0]);
@@ -445,7 +445,8 @@ asmlinkage long sys32_sched_rr_get_inter
 	mm_segment_t old_fs = get_fs ();
 	
 	set_fs (KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *) &t);
+	ret = sys_sched_rr_get_interval(pid,
+					(struct timespec __force __user *) &t);
 	set_fs (old_fs);
 	if (put_compat_timespec(&t, interval))
 		return -EFAULT;
@@ -472,8 +473,8 @@ asmlinkage long sys32_rt_sigprocmask(int
 	}
 	set_fs (KERNEL_DS);
 	ret = sys_rt_sigprocmask(how,
-				 set ? (sigset_t __user *) &s : NULL,
-				 oset ? (sigset_t __user *) &s : NULL,
+				 set ? (sigset_t __force __user *) &s : NULL,
+				 oset ? (sigset_t __force __user *) &s : NULL,
 				 sigsetsize);
 	set_fs (old_fs);
 	if (ret) return ret;
@@ -499,7 +500,7 @@ asmlinkage long sys32_rt_sigpending(comp
 	mm_segment_t old_fs = get_fs();
 		
 	set_fs (KERNEL_DS);
-	ret = sys_rt_sigpending((sigset_t __user *) &s, sigsetsize);
+	ret = sys_rt_sigpending((sigset_t __force __user *) &s, sigsetsize);
 	set_fs (old_fs);
 	if (!ret) {
 		switch (_NSIG_WORDS) {
@@ -524,7 +525,7 @@ sys32_rt_sigqueueinfo(int pid, int sig, 
 	if (copy_siginfo_from_user32(&info, uinfo))
 		return -EFAULT;
 	set_fs (KERNEL_DS);
-	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __user *) &info);
+	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __force __user *) &info);
 	set_fs (old_fs);
 	return ret;
 }
@@ -682,7 +683,7 @@ asmlinkage long sys32_sendfile(int out_f
 		
 	set_fs(KERNEL_DS);
 	ret = sys_sendfile(out_fd, in_fd,
-			   offset ? (off_t __user *) &of : NULL, count);
+			   offset ? (off_t __force __user *) &of : NULL, count);
 	set_fs(old_fs);
 	
 	if (offset && put_user(of, offset))
@@ -703,7 +704,8 @@ asmlinkage long sys32_sendfile64(int out
 		
 	set_fs(KERNEL_DS);
 	ret = sys_sendfile64(out_fd, in_fd,
-			     offset ? (loff_t __user *) &lof : NULL, count);
+			     offset ? (loff_t __force __user *) &lof : NULL,
+			     count);
 	set_fs(old_fs);
 	
 	if (offset && put_user(lof, offset))
diff -urpN linux-2.6/arch/s390/kernel/compat_signal.c linux-2.6-patched/arch/s390/kernel/compat_signal.c
--- linux-2.6/arch/s390/kernel/compat_signal.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/compat_signal.c	2007-01-26 17:27:46.000000000 +0100
@@ -275,8 +275,8 @@ sys32_sigaltstack(const stack_t32 __user
 	}
 
 	set_fs (KERNEL_DS);
-	ret = do_sigaltstack((stack_t __user *) (uss ? &kss : NULL),
-			     (stack_t __user *) (uoss ? &koss : NULL),
+	ret = do_sigaltstack((stack_t __force __user *) (uss ? &kss : NULL),
+			     (stack_t __force __user *) (uoss ? &koss : NULL),
 			     regs->gprs[15]);
 	set_fs (old_fs);
 
@@ -401,7 +401,7 @@ asmlinkage long sys32_rt_sigreturn(struc
 		goto badframe; 
 
 	set_fs (KERNEL_DS);
-	do_sigaltstack((stack_t __user *)&st, NULL, regs->gprs[15]);
+	do_sigaltstack((stack_t __force __user *)&st, NULL, regs->gprs[15]);
 	set_fs (old_fs);
 
 	return regs->gprs[2];
diff -urpN linux-2.6/arch/s390/kernel/crash.c linux-2.6-patched/arch/s390/kernel/crash.c
--- linux-2.6/arch/s390/kernel/crash.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/crash.c	2007-01-26 17:27:46.000000000 +0100
@@ -9,6 +9,7 @@
 
 #include <linux/threads.h>
 #include <linux/kexec.h>
+#include <linux/reboot.h>
 
 void machine_crash_shutdown(struct pt_regs *regs)
 {
diff -urpN linux-2.6/arch/s390/kernel/debug.c linux-2.6-patched/arch/s390/kernel/debug.c
--- linux-2.6/arch/s390/kernel/debug.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/debug.c	2007-01-26 17:27:46.000000000 +0100
@@ -120,7 +120,7 @@ struct debug_view debug_hex_ascii_view =
 	NULL
 };
 
-struct debug_view debug_level_view = {
+static struct debug_view debug_level_view = {
 	"level",
 	&debug_prolog_level_fn,
 	NULL,
@@ -129,7 +129,7 @@ struct debug_view debug_level_view = {
 	NULL
 };
 
-struct debug_view debug_pages_view = {
+static struct debug_view debug_pages_view = {
 	"pages",
 	&debug_prolog_pages_fn,
 	NULL,
@@ -138,7 +138,7 @@ struct debug_view debug_pages_view = {
 	NULL
 };
 
-struct debug_view debug_flush_view = {
+static struct debug_view debug_flush_view = {
         "flush",
         NULL,
         NULL,
@@ -156,14 +156,14 @@ struct debug_view debug_sprintf_view = {
 	NULL
 };
 
-
+/* used by dump analysis tools to determine version of debug feature */
 unsigned int debug_feature_version = __DEBUG_FEATURE_VERSION;
 
 /* static globals */
 
 static debug_info_t *debug_area_first = NULL;
 static debug_info_t *debug_area_last = NULL;
-DECLARE_MUTEX(debug_lock);
+static DECLARE_MUTEX(debug_lock);
 
 static int initialized;
 
@@ -905,7 +905,7 @@ static struct ctl_table s390dbf_dir_tabl
 	{ .ctl_name = 0 }
 };
 
-struct ctl_table_header *s390dbf_sysctl_header;
+static struct ctl_table_header *s390dbf_sysctl_header;
 
 void
 debug_stop_all(void)
@@ -1300,8 +1300,7 @@ out:
  * flushes debug areas
  */
  
-void
-debug_flush(debug_info_t* id, int area)
+static void debug_flush(debug_info_t* id, int area)
 {
         unsigned long flags;
         int i,j;
@@ -1511,8 +1510,7 @@ out:
 /*
  * clean up module
  */
-void
-__exit debug_exit(void)
+static void __exit debug_exit(void)
 {
 	debugfs_remove(debug_debugfs_root_entry);
 	unregister_sysctl_table(s390dbf_sysctl_header);
diff -urpN linux-2.6/arch/s390/kernel/ebcdic.c linux-2.6-patched/arch/s390/kernel/ebcdic.c
--- linux-2.6/arch/s390/kernel/ebcdic.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ebcdic.c	2007-01-26 17:27:46.000000000 +0100
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <asm/types.h>
+#include <asm/ebcdic.h>
 
 /*
  * ASCII (IBM PC 437)  -> EBCDIC 037
diff -urpN linux-2.6/arch/s390/kernel/kprobes.c linux-2.6-patched/arch/s390/kernel/kprobes.c
--- linux-2.6/arch/s390/kernel/kprobes.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/kprobes.c	2007-01-26 17:27:46.000000000 +0100
@@ -365,7 +365,8 @@ void __kprobes kretprobe_trampoline_hold
 /*
  * Called when the probe at kretprobe trampoline is hit
  */
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+static int __kprobes trampoline_probe_handler(struct kprobe *p,
+					      struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff -urpN linux-2.6/arch/s390/kernel/machine_kexec.c linux-2.6-patched/arch/s390/kernel/machine_kexec.c
--- linux-2.6/arch/s390/kernel/machine_kexec.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/machine_kexec.c	2007-01-26 17:27:46.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/kexec.h>
 #include <linux/delay.h>
+#include <linux/reboot.h>
 #include <asm/cio.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
diff -urpN linux-2.6/arch/s390/kernel/module.c linux-2.6-patched/arch/s390/kernel/module.c
--- linux-2.6/arch/s390/kernel/module.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/module.c	2007-01-26 17:27:46.000000000 +0100
@@ -30,6 +30,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/moduleloader.h>
 
 #if 0
 #define DEBUGP printk
diff -urpN linux-2.6/arch/s390/kernel/ptrace.c linux-2.6-patched/arch/s390/kernel/ptrace.c
--- linux-2.6/arch/s390/kernel/ptrace.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ptrace.c	2007-01-26 17:27:46.000000000 +0100
@@ -86,15 +86,13 @@ FixPerRegisters(struct task_struct *task
 		per_info->control_regs.bits.storage_alt_space_ctl = 0;
 }
 
-void
-set_single_step(struct task_struct *task)
+static void set_single_step(struct task_struct *task)
 {
 	task->thread.per_info.single_step = 1;
 	FixPerRegisters(task);
 }
 
-void
-clear_single_step(struct task_struct *task)
+static void clear_single_step(struct task_struct *task)
 {
 	task->thread.per_info.single_step = 0;
 	FixPerRegisters(task);
@@ -309,7 +307,7 @@ do_ptrace_normal(struct task_struct *chi
 		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
 		if (copied != sizeof(tmp))
 			return -EIO;
-		return put_user(tmp, (unsigned long __user *) data);
+		return put_user(tmp, (unsigned long __force __user *) data);
 
 	case PTRACE_PEEKUSR:
 		/* read the word at location addr in the USER area. */
@@ -331,7 +329,7 @@ do_ptrace_normal(struct task_struct *chi
 
 	case PTRACE_PEEKUSR_AREA:
 	case PTRACE_POKEUSR_AREA:
-		if (copy_from_user(&parea, (void __user *) addr,
+		if (copy_from_user(&parea, (void __force __user *) addr,
 							sizeof(parea)))
 			return -EFAULT;
 		addr = parea.kernel_addr;
@@ -341,10 +339,11 @@ do_ptrace_normal(struct task_struct *chi
 			if (request == PTRACE_PEEKUSR_AREA)
 				ret = peek_user(child, addr, data);
 			else {
-				addr_t tmp;
-				if (get_user (tmp, (addr_t __user *) data))
+				addr_t utmp;
+				if (get_user(utmp,
+					     (addr_t __force __user *) data))
 					return -EFAULT;
-				ret = poke_user(child, addr, tmp);
+				ret = poke_user(child, addr, utmp);
 			}
 			if (ret)
 				return ret;
@@ -550,7 +549,7 @@ do_ptrace_emu31(struct task_struct *chil
 		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
 		if (copied != sizeof(tmp))
 			return -EIO;
-		return put_user(tmp, (unsigned int __user *) data);
+		return put_user(tmp, (unsigned int __force __user *) data);
 
 	case PTRACE_PEEKUSR:
 		/* read the word at location addr in the USER area. */
@@ -571,7 +570,7 @@ do_ptrace_emu31(struct task_struct *chil
 
 	case PTRACE_PEEKUSR_AREA:
 	case PTRACE_POKEUSR_AREA:
-		if (copy_from_user(&parea, (void __user *) addr,
+		if (copy_from_user(&parea, (void __force __user *) addr,
 							sizeof(parea)))
 			return -EFAULT;
 		addr = parea.kernel_addr;
@@ -581,10 +580,11 @@ do_ptrace_emu31(struct task_struct *chil
 			if (request == PTRACE_PEEKUSR_AREA)
 				ret = peek_user_emu31(child, addr, data);
 			else {
-				__u32 tmp;
-				if (get_user (tmp, (__u32 __user *) data))
+				__u32 utmp;
+				if (get_user(utmp,
+					     (__u32 __force __user *) data))
 					return -EFAULT;
-				ret = poke_user_emu31(child, addr, tmp);
+				ret = poke_user_emu31(child, addr, utmp);
 			}
 			if (ret)
 				return ret;
@@ -595,17 +595,19 @@ do_ptrace_emu31(struct task_struct *chil
 		return 0;
 	case PTRACE_GETEVENTMSG:
 		return put_user((__u32) child->ptrace_message,
-				(unsigned int __user *) data);
+				(unsigned int __force __user *) data);
 	case PTRACE_GETSIGINFO:
 		if (child->last_siginfo == NULL)
 			return -EINVAL;
-		return copy_siginfo_to_user32((compat_siginfo_t __user *) data,
+		return copy_siginfo_to_user32((compat_siginfo_t
+					       __force __user *) data,
 					      child->last_siginfo);
 	case PTRACE_SETSIGINFO:
 		if (child->last_siginfo == NULL)
 			return -EINVAL;
 		return copy_siginfo_from_user32(child->last_siginfo,
-						(compat_siginfo_t __user *) data);
+						(compat_siginfo_t
+						 __force __user *) data);
 	}
 	return ptrace_request(child, request, addr, data);
 }
diff -urpN linux-2.6/arch/s390/kernel/setup.c linux-2.6-patched/arch/s390/kernel/setup.c
--- linux-2.6/arch/s390/kernel/setup.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/setup.c	2007-01-26 17:27:46.000000000 +0100
@@ -38,6 +38,7 @@
 #include <linux/device.h>
 #include <linux/notifier.h>
 #include <linux/pfn.h>
+#include <linux/reboot.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -117,7 +118,7 @@ void __devinit cpu_init (void)
  */
 char vmhalt_cmd[128] = "";
 char vmpoff_cmd[128] = "";
-char vmpanic_cmd[128] = "";
+static char vmpanic_cmd[128] = "";
 
 static inline void strncpy_skip_quote(char *dst, char *src, int n)
 {
@@ -275,10 +276,6 @@ static void __init conmode_default(void)
 }
 
 #ifdef CONFIG_SMP
-extern void machine_restart_smp(char *);
-extern void machine_halt_smp(void);
-extern void machine_power_off_smp(void);
-
 void (*_machine_restart)(char *command) = machine_restart_smp;
 void (*_machine_halt)(void) = machine_halt_smp;
 void (*_machine_power_off)(void) = machine_power_off_smp;
diff -urpN linux-2.6/arch/s390/kernel/smp.c linux-2.6-patched/arch/s390/kernel/smp.c
--- linux-2.6/arch/s390/kernel/smp.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/smp.c	2007-01-26 17:27:46.000000000 +0100
@@ -22,23 +22,23 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-
 #include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <linux/kernel_stat.h>
 #include <linux/smp_lock.h>
-
 #include <linux/delay.h>
 #include <linux/cache.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
-
+#include <linux/timex.h>
+#include <asm/setup.h>
 #include <asm/sigp.h>
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
 #include <asm/s390_ext.h>
 #include <asm/cpcmd.h>
 #include <asm/tlbflush.h>
+#include <asm/timer.h>
 
 extern volatile int __cpu_logical_map[];
 
@@ -53,12 +53,6 @@ cpumask_t cpu_possible_map = CPU_MASK_NO
 
 static struct task_struct *current_set[NR_CPUS];
 
-/*
- * Reboot, halt and power_off routines for SMP.
- */
-extern char vmhalt_cmd[];
-extern char vmpoff_cmd[];
-
 static void smp_ext_bitcall(int, ec_bit_sig);
 static void smp_ext_bitcall_others(ec_bit_sig);
 
@@ -298,7 +292,7 @@ void machine_power_off_smp(void)
  * cpus are handled.
  */
 
-void do_ext_call_interrupt(__u16 code)
+static void do_ext_call_interrupt(__u16 code)
 {
         unsigned long bits;
 
@@ -385,7 +379,7 @@ struct ec_creg_mask_parms {
 /*
  * callback for setting/clearing control bits
  */
-void smp_ctl_bit_callback(void *info) {
+static void smp_ctl_bit_callback(void *info) {
 	struct ec_creg_mask_parms *pp = info;
 	unsigned long cregs[16];
 	int i;
@@ -458,9 +452,6 @@ __init smp_count_cpus(void)
 /*
  *      Activate a secondary processor.
  */
-extern void init_cpu_timer(void);
-extern void init_cpu_vtimer(void);
-
 int __devinit start_secondary(void *cpuvoid)
 {
         /* Setup the cpu */
diff -urpN linux-2.6/arch/s390/kernel/time.c linux-2.6-patched/arch/s390/kernel/time.c
--- linux-2.6/arch/s390/kernel/time.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/time.c	2007-01-26 17:27:46.000000000 +0100
@@ -245,7 +245,7 @@ static struct notifier_block nohz_idle_n
 	.notifier_call = nohz_idle_notify,
 };
 
-void __init nohz_init(void)
+static void __init nohz_init(void)
 {
 	if (register_idle_notifier(&nohz_idle_nb))
 		panic("Couldn't register idle notifier");
@@ -271,8 +271,6 @@ void init_cpu_timer(void)
 	__ctl_load(cr0, 0, 0);
 }
 
-extern void vtime_init(void);
-
 static cycle_t read_tod_clock(void)
 {
 	return get_clock();
diff -urpN linux-2.6/arch/s390/kernel/traps.c linux-2.6-patched/arch/s390/kernel/traps.c
--- linux-2.6/arch/s390/kernel/traps.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/traps.c	2007-01-26 17:27:46.000000000 +0100
@@ -283,7 +283,7 @@ char *task_show_regs(struct task_struct 
 	return buffer;
 }
 
-DEFINE_SPINLOCK(die_lock);
+static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
 {
@@ -364,8 +364,7 @@ void __kprobes do_single_step(struct pt_
 		force_sig(SIGTRAP, current);
 }
 
-asmlinkage void
-default_trap_handler(struct pt_regs * regs, long interruption_code)
+static void default_trap_handler(struct pt_regs * regs, long interruption_code)
 {
         if (regs->psw.mask & PSW_MASK_PSTATE) {
 		local_irq_enable();
@@ -376,7 +375,7 @@ default_trap_handler(struct pt_regs * re
 }
 
 #define DO_ERROR_INFO(signr, str, name, sicode, siaddr) \
-asmlinkage void name(struct pt_regs * regs, long interruption_code) \
+static void name(struct pt_regs * regs, long interruption_code) \
 { \
         siginfo_t info; \
         info.si_signo = signr; \
@@ -442,7 +441,7 @@ do_fp_trap(struct pt_regs *regs, void __
 		"floating point exception", regs, &si);
 }
 
-asmlinkage void illegal_op(struct pt_regs * regs, long interruption_code)
+static void illegal_op(struct pt_regs * regs, long interruption_code)
 {
 	siginfo_t info;
         __u8 opcode[6];
@@ -585,7 +584,7 @@ DO_ERROR_INFO(SIGILL, "specification exc
 	      ILL_ILLOPN, get_check_address(regs));
 #endif
 
-asmlinkage void data_exception(struct pt_regs * regs, long interruption_code)
+static void data_exception(struct pt_regs * regs, long interruption_code)
 {
 	__u16 __user *location;
 	int signal = 0;
@@ -675,7 +674,7 @@ asmlinkage void data_exception(struct pt
 	}
 }
 
-asmlinkage void space_switch_exception(struct pt_regs * regs, long int_code)
+static void space_switch_exception(struct pt_regs * regs, long int_code)
 {
         siginfo_t info;
 
diff -urpN linux-2.6/arch/s390/kernel/vtime.c linux-2.6-patched/arch/s390/kernel/vtime.c
--- linux-2.6/arch/s390/kernel/vtime.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/vtime.c	2007-01-26 17:27:46.000000000 +0100
@@ -25,7 +25,7 @@
 #include <asm/irq_regs.h>
 
 static ext_int_info_t ext_int_info_timer;
-DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
+static DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 /*
diff -urpN linux-2.6/arch/s390/lib/uaccess.h linux-2.6-patched/arch/s390/lib/uaccess.h
--- linux-2.6/arch/s390/lib/uaccess.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/uaccess.h	2007-01-26 17:27:46.000000000 +0100
@@ -0,0 +1,23 @@
+/*
+ *  arch/s390/uaccess.h
+ *
+ *    Copyright IBM Corp. 2007
+ *
+ */
+
+#ifndef __ARCH_S390_LIB_UACCESS_H
+#define __ARCH_S390_LIB_UACCESS_H
+
+extern size_t copy_from_user_std(size_t, const void __user *, void *);
+extern size_t copy_to_user_std(size_t, void __user *, const void *);
+extern size_t strnlen_user_std(size_t, const char __user *);
+extern size_t strncpy_from_user_std(size_t, const char __user *, char *);
+extern int futex_atomic_cmpxchg_std(int __user *, int, int);
+extern int futex_atomic_op_std(int, int __user *, int, int *);
+
+extern size_t copy_from_user_pt(size_t, const void __user *, void *);
+extern size_t copy_to_user_pt(size_t, void __user *, const void *);
+extern int futex_atomic_op_pt(int, int __user *, int, int *);
+extern int futex_atomic_cmpxchg_pt(int __user *, int, int);
+
+#endif /* __ARCH_S390_LIB_UACCESS_H */
diff -urpN linux-2.6/arch/s390/lib/uaccess_mvcos.c linux-2.6-patched/arch/s390/lib/uaccess_mvcos.c
--- linux-2.6/arch/s390/lib/uaccess_mvcos.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/uaccess_mvcos.c	2007-01-26 17:27:46.000000000 +0100
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <asm/uaccess.h>
 #include <asm/futex.h>
+#include "uaccess.h"
 
 #ifndef __s390x__
 #define AHI	"ahi"
@@ -27,10 +28,7 @@
 #define SLR	"slgr"
 #endif
 
-extern size_t copy_from_user_std(size_t, const void __user *, void *);
-extern size_t copy_to_user_std(size_t, void __user *, const void *);
-
-size_t copy_from_user_mvcos(size_t size, const void __user *ptr, void *x)
+static size_t copy_from_user_mvcos(size_t size, const void __user *ptr, void *x)
 {
 	register unsigned long reg0 asm("0") = 0x81UL;
 	unsigned long tmp1, tmp2;
@@ -69,14 +67,14 @@ size_t copy_from_user_mvcos(size_t size,
 	return size;
 }
 
-size_t copy_from_user_mvcos_check(size_t size, const void __user *ptr, void *x)
+static size_t copy_from_user_mvcos_check(size_t size, const void __user *ptr, void *x)
 {
 	if (size <= 256)
 		return copy_from_user_std(size, ptr, x);
 	return copy_from_user_mvcos(size, ptr, x);
 }
 
-size_t copy_to_user_mvcos(size_t size, void __user *ptr, const void *x)
+static size_t copy_to_user_mvcos(size_t size, void __user *ptr, const void *x)
 {
 	register unsigned long reg0 asm("0") = 0x810000UL;
 	unsigned long tmp1, tmp2;
@@ -105,14 +103,16 @@ size_t copy_to_user_mvcos(size_t size, v
 	return size;
 }
 
-size_t copy_to_user_mvcos_check(size_t size, void __user *ptr, const void *x)
+static size_t copy_to_user_mvcos_check(size_t size, void __user *ptr,
+				       const void *x)
 {
 	if (size <= 256)
 		return copy_to_user_std(size, ptr, x);
 	return copy_to_user_mvcos(size, ptr, x);
 }
 
-size_t copy_in_user_mvcos(size_t size, void __user *to, const void __user *from)
+static size_t copy_in_user_mvcos(size_t size, void __user *to,
+				 const void __user *from)
 {
 	register unsigned long reg0 asm("0") = 0x810081UL;
 	unsigned long tmp1, tmp2;
@@ -134,7 +134,7 @@ size_t copy_in_user_mvcos(size_t size, v
 	return size;
 }
 
-size_t clear_user_mvcos(size_t size, void __user *to)
+static size_t clear_user_mvcos(size_t size, void __user *to)
 {
 	register unsigned long reg0 asm("0") = 0x810000UL;
 	unsigned long tmp1, tmp2;
@@ -162,11 +162,6 @@ size_t clear_user_mvcos(size_t size, voi
 	return size;
 }
 
-extern size_t strnlen_user_std(size_t, const char __user *);
-extern size_t strncpy_from_user_std(size_t, const char __user *, char *);
-extern int futex_atomic_op(int, int __user *, int, int *);
-extern int futex_atomic_cmpxchg(int __user *, int, int);
-
 struct uaccess_ops uaccess_mvcos = {
 	.copy_from_user = copy_from_user_mvcos_check,
 	.copy_from_user_small = copy_from_user_std,
@@ -176,6 +171,6 @@ struct uaccess_ops uaccess_mvcos = {
 	.clear_user = clear_user_mvcos,
 	.strnlen_user = strnlen_user_std,
 	.strncpy_from_user = strncpy_from_user_std,
-	.futex_atomic_op = futex_atomic_op,
-	.futex_atomic_cmpxchg = futex_atomic_cmpxchg,
+	.futex_atomic_op = futex_atomic_op_std,
+	.futex_atomic_cmpxchg = futex_atomic_cmpxchg_std,
 };
diff -urpN linux-2.6/arch/s390/lib/uaccess_pt.c linux-2.6-patched/arch/s390/lib/uaccess_pt.c
--- linux-2.6/arch/s390/lib/uaccess_pt.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/uaccess_pt.c	2007-01-26 17:27:46.000000000 +0100
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <asm/uaccess.h>
 #include <asm/futex.h>
+#include "uaccess.h"
 
 static inline int __handle_fault(struct mm_struct *mm, unsigned long address,
 				 int write_access)
diff -urpN linux-2.6/arch/s390/lib/uaccess_std.c linux-2.6-patched/arch/s390/lib/uaccess_std.c
--- linux-2.6/arch/s390/lib/uaccess_std.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/uaccess_std.c	2007-01-26 17:27:46.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <asm/futex.h>
+#include "uaccess.h"
 
 #ifndef __s390x__
 #define AHI	"ahi"
@@ -28,9 +29,6 @@
 #define SLR	"slgr"
 #endif
 
-extern size_t copy_from_user_pt(size_t n, const void __user *from, void *to);
-extern size_t copy_to_user_pt(size_t n, void __user *to, const void *from);
-
 size_t copy_from_user_std(size_t size, const void __user *ptr, void *x)
 {
 	unsigned long tmp1, tmp2;
@@ -72,7 +70,8 @@ size_t copy_from_user_std(size_t size, c
 	return size;
 }
 
-size_t copy_from_user_std_check(size_t size, const void __user *ptr, void *x)
+static size_t copy_from_user_std_check(size_t size, const void __user *ptr,
+				       void *x)
 {
 	if (size <= 1024)
 		return copy_from_user_std(size, ptr, x);
@@ -110,14 +109,16 @@ size_t copy_to_user_std(size_t size, voi
 	return size;
 }
 
-size_t copy_to_user_std_check(size_t size, void __user *ptr, const void *x)
+static size_t copy_to_user_std_check(size_t size, void __user *ptr,
+				     const void *x)
 {
 	if (size <= 1024)
 		return copy_to_user_std(size, ptr, x);
 	return copy_to_user_pt(size, ptr, x);
 }
 
-size_t copy_in_user_std(size_t size, void __user *to, const void __user *from)
+static size_t copy_in_user_std(size_t size, void __user *to,
+			       const void __user *from)
 {
 	unsigned long tmp1;
 
@@ -148,7 +149,7 @@ size_t copy_in_user_std(size_t size, voi
 	return size;
 }
 
-size_t clear_user_std(size_t size, void __user *to)
+static size_t clear_user_std(size_t size, void __user *to)
 {
 	unsigned long tmp1, tmp2;
 
@@ -254,7 +255,7 @@ size_t strncpy_from_user_std(size_t size
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\
 		  "m" (*uaddr) : "cc");
 
-int futex_atomic_op(int op, int __user *uaddr, int oparg, int *old)
+int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
 {
 	int oldval = 0, newval, ret;
 
@@ -286,7 +287,7 @@ int futex_atomic_op(int op, int __user *
 	return ret;
 }
 
-int futex_atomic_cmpxchg(int __user *uaddr, int oldval, int newval)
+int futex_atomic_cmpxchg_std(int __user *uaddr, int oldval, int newval)
 {
 	int ret;
 
@@ -311,6 +312,6 @@ struct uaccess_ops uaccess_std = {
 	.clear_user = clear_user_std,
 	.strnlen_user = strnlen_user_std,
 	.strncpy_from_user = strncpy_from_user_std,
-	.futex_atomic_op = futex_atomic_op,
-	.futex_atomic_cmpxchg = futex_atomic_cmpxchg,
+	.futex_atomic_op = futex_atomic_op_std,
+	.futex_atomic_cmpxchg = futex_atomic_cmpxchg_std,
 };
diff -urpN linux-2.6/arch/s390/mm/cmm.c linux-2.6-patched/arch/s390/mm/cmm.c
--- linux-2.6/arch/s390/mm/cmm.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/cmm.c	2007-01-26 17:27:46.000000000 +0100
@@ -414,7 +414,7 @@ cmm_smsg_target(char *from, char *msg)
 }
 #endif
 
-struct ctl_table_header *cmm_sysctl_header;
+static struct ctl_table_header *cmm_sysctl_header;
 
 static int
 cmm_init (void)
diff -urpN linux-2.6/arch/s390/mm/fault.c linux-2.6-patched/arch/s390/mm/fault.c
--- linux-2.6/arch/s390/mm/fault.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/fault.c	2007-01-26 17:27:46.000000000 +0100
@@ -52,7 +52,7 @@ extern int sysctl_userprocess_debug;
 extern void die(const char *,struct pt_regs *,long);
 
 #ifdef CONFIG_KPROBES
-ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
+static ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
 int register_page_fault_notifier(struct notifier_block *nb)
 {
 	return atomic_notifier_chain_register(&notify_page_fault_chain, nb);
@@ -452,8 +452,7 @@ void pfault_fini(void)
 		: : "a" (&refbk), "m" (refbk) : "cc");
 }
 
-asmlinkage void
-pfault_interrupt(__u16 error_code)
+static void pfault_interrupt(__u16 error_code)
 {
 	struct task_struct *tsk;
 	__u16 subcode;
diff -urpN linux-2.6/arch/s390/mm/init.c linux-2.6-patched/arch/s390/mm/init.c
--- linux-2.6/arch/s390/mm/init.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/init.c	2007-01-26 17:27:46.000000000 +0100
@@ -25,6 +25,7 @@
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
 #include <linux/poison.h>
+#include <linux/initrd.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -107,8 +108,6 @@ static void __init setup_ro_region(void)
 	}
 }
 
-extern void vmem_map_init(void);
-
 /*
  * paging_init() sets up the page tables
  */
diff -urpN linux-2.6/drivers/s390/block/dasd.c linux-2.6-patched/drivers/s390/block/dasd.c
--- linux-2.6/drivers/s390/block/dasd.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd.c	2007-01-26 17:27:46.000000000 +0100
@@ -37,6 +37,7 @@
  */
 debug_info_t *dasd_debug_area;
 struct dasd_discipline *dasd_diag_discipline_pointer;
+void dasd_int_handler(struct ccw_device *, unsigned long, struct irb *);
 
 MODULE_AUTHOR("Holger Smolinski <Holger.Smolinski@de.ibm.com>");
 MODULE_DESCRIPTION("Linux on S/390 DASD device driver,"
@@ -51,7 +52,6 @@ static int  dasd_alloc_queue(struct dasd
 static void dasd_setup_queue(struct dasd_device * device);
 static void dasd_free_queue(struct dasd_device * device);
 static void dasd_flush_request_queue(struct dasd_device *);
-static void dasd_int_handler(struct ccw_device *, unsigned long, struct irb *);
 static int dasd_flush_ccw_queue(struct dasd_device *, int);
 static void dasd_tasklet(struct dasd_device *);
 static void do_kick_device(struct work_struct *);
diff -urpN linux-2.6/drivers/s390/block/dasd_diag.c linux-2.6-patched/drivers/s390/block/dasd_diag.c
--- linux-2.6/drivers/s390/block/dasd_diag.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_diag.c	2007-01-26 17:27:46.000000000 +0100
@@ -43,7 +43,7 @@ MODULE_LICENSE("GPL");
 #define DIAG_MAX_RETRIES	32
 #define DIAG_TIMEOUT		50 * HZ
 
-struct dasd_discipline dasd_diag_discipline;
+static struct dasd_discipline dasd_diag_discipline;
 
 struct dasd_diag_private {
 	struct dasd_diag_characteristics rdc_data;
@@ -576,7 +576,7 @@ dasd_diag_dump_sense(struct dasd_device 
 		    "dump sense not available for DIAG data");
 }
 
-struct dasd_discipline dasd_diag_discipline = {
+static struct dasd_discipline dasd_diag_discipline = {
 	.owner = THIS_MODULE,
 	.name = "DIAG",
 	.ebcname = "DIAG",
diff -urpN linux-2.6/drivers/s390/block/dasd_eckd.c linux-2.6-patched/drivers/s390/block/dasd_eckd.c
--- linux-2.6/drivers/s390/block/dasd_eckd.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_eckd.c	2007-01-26 17:27:46.000000000 +0100
@@ -548,7 +548,7 @@ dasd_eckd_read_conf(struct dasd_device *
 /*
  * Build CP for Perform Subsystem Function - SSC.
  */
-struct dasd_ccw_req *
+static struct dasd_ccw_req *
 dasd_eckd_build_psf_ssc(struct dasd_device *device)
 {
        struct dasd_ccw_req *cqr;
diff -urpN linux-2.6/drivers/s390/block/dasd_genhd.c linux-2.6-patched/drivers/s390/block/dasd_genhd.c
--- linux-2.6/drivers/s390/block/dasd_genhd.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_genhd.c	2007-01-26 17:27:46.000000000 +0100
@@ -147,7 +147,7 @@ dasd_destroy_partitions(struct dasd_devi
 	 */
 	memset(&bpart, 0, sizeof(struct blkpg_partition));
 	memset(&barg, 0, sizeof(struct blkpg_ioctl_arg));
-	barg.data = (void __user *) &bpart;
+	barg.data = (void __force __user *) &bpart;
 	barg.op = BLKPG_DEL_PARTITION;
 	for (bpart.pno = device->gdp->minors - 1; bpart.pno > 0; bpart.pno--)
 		ioctl_by_bdev(bdev, BLKPG, (unsigned long) &barg);
diff -urpN linux-2.6/drivers/s390/block/dasd_proc.c linux-2.6-patched/drivers/s390/block/dasd_proc.c
--- linux-2.6/drivers/s390/block/dasd_proc.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/block/dasd_proc.c	2007-01-26 17:27:46.000000000 +0100
@@ -168,7 +168,7 @@ dasd_calc_metrics(char *page, char **sta
 }
 
 static inline char *
-dasd_statistics_array(char *str, int *array, int shift)
+dasd_statistics_array(char *str, unsigned int *array, int shift)
 {
 	int i;
 
diff -urpN linux-2.6/drivers/s390/char/con3215.c linux-2.6-patched/drivers/s390/char/con3215.c
--- linux-2.6/drivers/s390/char/con3215.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/con3215.c	2007-01-26 17:27:46.000000000 +0100
@@ -1121,7 +1121,7 @@ static const struct tty_operations tty32
  * 3215 tty registration code called from tty_init().
  * Most kernel services (incl. kmalloc) are available at this poimt.
  */
-int __init
+static int __init
 tty3215_init(void)
 {
 	struct tty_driver *driver;
diff -urpN linux-2.6/drivers/s390/char/con3270.c linux-2.6-patched/drivers/s390/char/con3270.c
--- linux-2.6/drivers/s390/char/con3270.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/con3270.c	2007-01-26 17:27:46.000000000 +0100
@@ -69,8 +69,7 @@ static void con3270_update(struct con327
 /*
  * Setup timeout for a device. On timeout trigger an update.
  */
-void
-con3270_set_timer(struct con3270 *cp, int expires)
+static void con3270_set_timer(struct con3270 *cp, int expires)
 {
 	if (expires == 0) {
 		if (timer_pending(&cp->timer))
diff -urpN linux-2.6/drivers/s390/char/defkeymap.c linux-2.6-patched/drivers/s390/char/defkeymap.c
--- linux-2.6/drivers/s390/char/defkeymap.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/defkeymap.c	2007-01-26 17:27:46.000000000 +0100
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <linux/keyboard.h>
 #include <linux/kd.h>
+#include <linux/kbd_kern.h>
+#include <linux/kbd_diacr.h>
 
 u_short plain_map[NR_KEYS] = {
 	0xf000,	0xf000,	0xf000,	0xf000,	0xf000,	0xf000,	0xf000,	0xf000,
diff -urpN linux-2.6/drivers/s390/char/fs3270.c linux-2.6-patched/drivers/s390/char/fs3270.c
--- linux-2.6/drivers/s390/char/fs3270.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/fs3270.c	2007-01-26 17:27:46.000000000 +0100
@@ -23,7 +23,7 @@
 #include "raw3270.h"
 #include "ctrlchar.h"
 
-struct raw3270_fn fs3270_fn;
+static struct raw3270_fn fs3270_fn;
 
 struct fs3270 {
 	struct raw3270_view view;
@@ -401,7 +401,7 @@ fs3270_release(struct raw3270_view *view
 }
 
 /* View to a 3270 device. Can be console, tty or fullscreen. */
-struct raw3270_fn fs3270_fn = {
+static struct raw3270_fn fs3270_fn = {
 	.activate = fs3270_activate,
 	.deactivate = fs3270_deactivate,
 	.intv = (void *) fs3270_irq,
diff -urpN linux-2.6/drivers/s390/char/keyboard.c linux-2.6-patched/drivers/s390/char/keyboard.c
--- linux-2.6/drivers/s390/char/keyboard.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/keyboard.c	2007-01-26 17:27:46.000000000 +0100
@@ -148,6 +148,7 @@ kbd_ascebc(struct kbd_data *kbd, unsigne
 	}
 }
 
+#if 0
 /*
  * Generate ebcdic -> ascii translation table from kbd_data.
  */
@@ -173,6 +174,7 @@ kbd_ebcasc(struct kbd_data *kbd, unsigne
 		}
 	}
 }
+#endif
 
 /*
  * We have a combining character DIACR here, followed by the character CH.
diff -urpN linux-2.6/drivers/s390/char/raw3270.c linux-2.6-patched/drivers/s390/char/raw3270.c
--- linux-2.6/drivers/s390/char/raw3270.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/raw3270.c	2007-01-26 17:27:46.000000000 +0100
@@ -29,7 +29,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 
-struct class *class3270;
+static struct class *class3270;
 
 /* The main 3270 data structure. */
 struct raw3270 {
@@ -86,7 +86,7 @@ DECLARE_WAIT_QUEUE_HEAD(raw3270_wait_que
 /*
  * Encode array for 12 bit 3270 addresses.
  */
-unsigned char raw3270_ebcgraf[64] =	{
+static unsigned char raw3270_ebcgraf[64] =	{
 	0x40, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
 	0xc8, 0xc9, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f,
 	0x50, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,
diff -urpN linux-2.6/drivers/s390/char/sclp_tty.c linux-2.6-patched/drivers/s390/char/sclp_tty.c
--- linux-2.6/drivers/s390/char/sclp_tty.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_tty.c	2007-01-26 17:27:46.000000000 +0100
@@ -721,7 +721,7 @@ static const struct tty_operations sclp_
 	.ioctl = sclp_tty_ioctl,
 };
 
-int __init
+static int __init
 sclp_tty_init(void)
 {
 	struct tty_driver *driver;
diff -urpN linux-2.6/drivers/s390/char/sclp_vt220.c linux-2.6-patched/drivers/s390/char/sclp_vt220.c
--- linux-2.6/drivers/s390/char/sclp_vt220.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_vt220.c	2007-01-26 17:27:46.000000000 +0100
@@ -669,7 +669,7 @@ static const struct tty_operations sclp_
 /*
  * Register driver with SCLP and Linux and initialize internal tty structures.
  */
-int __init
+static int __init
 sclp_vt220_tty_init(void)
 {
 	struct tty_driver *driver;
diff -urpN linux-2.6/drivers/s390/char/tape_char.c linux-2.6-patched/drivers/s390/char/tape_char.c
--- linux-2.6/drivers/s390/char/tape_char.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tape_char.c	2007-01-26 17:27:46.000000000 +0100
@@ -137,7 +137,7 @@ tapechar_check_idalbuffer(struct tape_de
 /*
  * Tape device read function
  */
-ssize_t
+static ssize_t
 tapechar_read(struct file *filp, char __user *data, size_t count, loff_t *ppos)
 {
 	struct tape_device *device;
@@ -201,7 +201,7 @@ tapechar_read(struct file *filp, char __
 /*
  * Tape device write function
  */
-ssize_t
+static ssize_t
 tapechar_write(struct file *filp, const char __user *data, size_t count, loff_t *ppos)
 {
 	struct tape_device *device;
@@ -291,7 +291,7 @@ tapechar_write(struct file *filp, const 
 /*
  * Character frontend tape device open function.
  */
-int
+static int
 tapechar_open (struct inode *inode, struct file *filp)
 {
 	struct tape_device *device;
@@ -326,7 +326,7 @@ tapechar_open (struct inode *inode, stru
  * Character frontend tape device release function.
  */
 
-int
+static int
 tapechar_release(struct inode *inode, struct file *filp)
 {
 	struct tape_device *device;
diff -urpN linux-2.6/drivers/s390/char/tty3270.c linux-2.6-patched/drivers/s390/char/tty3270.c
--- linux-2.6/drivers/s390/char/tty3270.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tty3270.c	2007-01-26 17:27:46.000000000 +0100
@@ -36,7 +36,7 @@
 struct tty_driver *tty3270_driver;
 static int tty3270_max_index;
 
-struct raw3270_fn tty3270_fn;
+static struct raw3270_fn tty3270_fn;
 
 struct tty3270_cell {
 	unsigned char character;
@@ -119,8 +119,7 @@ static void tty3270_update(struct tty327
 /*
  * Setup timeout for a device. On timeout trigger an update.
  */
-void
-tty3270_set_timer(struct tty3270 *tp, int expires)
+static void tty3270_set_timer(struct tty3270 *tp, int expires)
 {
 	if (expires == 0) {
 		if (timer_pending(&tp->timer) && del_timer(&tp->timer))
@@ -841,7 +840,7 @@ tty3270_del_views(void)
 	}
 }
 
-struct raw3270_fn tty3270_fn = {
+static struct raw3270_fn tty3270_fn = {
 	.activate = tty3270_activate,
 	.deactivate = tty3270_deactivate,
 	.intv = (void *) tty3270_irq,
@@ -1754,8 +1753,7 @@ static const struct tty_operations tty32
 	.set_termios = tty3270_set_termios
 };
 
-void
-tty3270_notifier(int index, int active)
+static void tty3270_notifier(int index, int active)
 {
 	if (active)
 		tty_register_device(tty3270_driver, index, NULL);
@@ -1767,8 +1765,7 @@ tty3270_notifier(int index, int active)
  * 3270 tty registration code called from tty_init().
  * Most kernel services (incl. kmalloc) are available at this poimt.
  */
-int __init
-tty3270_init(void)
+static int __init tty3270_init(void)
 {
 	struct tty_driver *driver;
 	int ret;
diff -urpN linux-2.6/drivers/s390/char/vmlogrdr.c linux-2.6-patched/drivers/s390/char/vmlogrdr.c
--- linux-2.6/drivers/s390/char/vmlogrdr.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/vmlogrdr.c	2007-01-26 17:27:46.000000000 +0100
@@ -128,9 +128,8 @@ static iucv_interrupt_ops_t vmlogrdr_iuc
 	.MessagePending     = vmlogrdr_iucv_MessagePending,
 };
 
-
-DECLARE_WAIT_QUEUE_HEAD(conn_wait_queue);
-DECLARE_WAIT_QUEUE_HEAD(read_wait_queue);
+static DECLARE_WAIT_QUEUE_HEAD(conn_wait_queue);
+static DECLARE_WAIT_QUEUE_HEAD(read_wait_queue);
 
 /*
  * pointer to system service private structure
diff -urpN linux-2.6/drivers/s390/cio/blacklist.c linux-2.6-patched/drivers/s390/cio/blacklist.c
--- linux-2.6/drivers/s390/cio/blacklist.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/blacklist.c	2007-01-26 17:27:46.000000000 +0100
@@ -126,7 +126,7 @@ confused:
 static inline int
 blacklist_parse_parameters (char *str, range_action action)
 {
-	unsigned int from, to, from_id0, to_id0, from_ssid, to_ssid;
+	int from, to, from_id0, to_id0, from_ssid, to_ssid;
 
 	while (*str != 0 && *str != '\n') {
 		range_action ra = action;
diff -urpN linux-2.6/drivers/s390/cio/chsc.h linux-2.6-patched/drivers/s390/cio/chsc.h
--- linux-2.6/drivers/s390/cio/chsc.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/chsc.h	2007-01-26 17:27:46.000000000 +0100
@@ -47,6 +47,9 @@ struct channel_path {
 extern void s390_process_css( void );
 extern void chsc_validate_chpids(struct subchannel *);
 extern void chpid_is_actually_online(int);
+extern int css_get_ssd_info(struct subchannel *);
+extern int chsc_process_crw(void);
+extern int chp_process_crw(int, int);
 
 struct css_general_char {
 	u64 : 41;
diff -urpN linux-2.6/drivers/s390/cio/css.c linux-2.6-patched/drivers/s390/cio/css.c
--- linux-2.6/drivers/s390/cio/css.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/css.c	2007-01-26 17:27:46.000000000 +0100
@@ -108,9 +108,6 @@ css_subchannel_release(struct device *de
 	}
 }
 
-extern int css_get_ssd_info(struct subchannel *sch);
-
-
 int css_sch_device_register(struct subchannel *sch)
 {
 	int ret;
@@ -417,7 +414,7 @@ static void reprobe_all(struct work_stru
 		      need_reprobe);
 }
 
-DECLARE_WORK(css_reprobe_work, reprobe_all);
+static DECLARE_WORK(css_reprobe_work, reprobe_all);
 
 /* Schedule reprobing of all unregistered subchannels. */
 void css_schedule_reprobe(void)
diff -urpN linux-2.6/drivers/s390/cio/css.h linux-2.6-patched/drivers/s390/cio/css.h
--- linux-2.6/drivers/s390/cio/css.h	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/css.h	2007-01-26 17:27:46.000000000 +0100
@@ -143,6 +143,8 @@ extern void css_sch_device_unregister(st
 extern struct subchannel * get_subchannel_by_schid(struct subchannel_id);
 extern int css_init_done;
 extern int for_each_subchannel(int(*fn)(struct subchannel_id, void *), void *);
+extern int css_process_crw(int, int);
+extern void css_reiterate_subchannels(void);
 
 #define __MAX_SUBCHANNEL 65535
 #define __MAX_SSID 3
diff -urpN linux-2.6/drivers/s390/cio/device.c linux-2.6-patched/drivers/s390/cio/device.c
--- linux-2.6/drivers/s390/cio/device.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device.c	2007-01-26 17:27:46.000000000 +0100
@@ -138,7 +138,6 @@ struct bus_type ccw_bus_type;
 
 static int io_subchannel_probe (struct subchannel *);
 static int io_subchannel_remove (struct subchannel *);
-void io_subchannel_irq (struct device *);
 static int io_subchannel_notify(struct device *, int);
 static void io_subchannel_verify(struct device *);
 static void io_subchannel_ioterm(struct device *);
diff -urpN linux-2.6/drivers/s390/cio/device_fsm.c linux-2.6-patched/drivers/s390/cio/device_fsm.c
--- linux-2.6/drivers/s390/cio/device_fsm.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device_fsm.c	2007-01-26 17:27:46.000000000 +0100
@@ -892,7 +892,7 @@ ccw_device_online_timeout(struct ccw_dev
 /*
  * Got an interrupt for a basic sense.
  */
-void
+static void
 ccw_device_w4sense(struct ccw_device *cdev, enum dev_event dev_event)
 {
 	struct irb *irb;
diff -urpN linux-2.6/drivers/s390/cio/device.h linux-2.6-patched/drivers/s390/cio/device.h
--- linux-2.6/drivers/s390/cio/device.h	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device.h	2007-01-26 17:27:46.000000000 +0100
@@ -74,6 +74,7 @@ extern struct workqueue_struct *ccw_devi
 extern wait_queue_head_t ccw_device_init_wq;
 extern atomic_t ccw_device_init_count;
 
+void io_subchannel_irq (struct device *pdev);
 void io_subchannel_recog_done(struct ccw_device *cdev);
 
 int ccw_device_cancel_halt_clear(struct ccw_device *);
@@ -118,6 +119,7 @@ int ccw_device_stlck(struct ccw_device *
 /* qdio needs this. */
 void ccw_device_set_timeout(struct ccw_device *, int);
 extern struct subchannel_id ccw_device_get_subchannel_id(struct ccw_device *);
+extern struct bus_type ccw_bus_type;
 
 /* Channel measurement facility related */
 void retry_set_schib(struct ccw_device *cdev);
diff -urpN linux-2.6/drivers/s390/cio/qdio.c linux-2.6-patched/drivers/s390/cio/qdio.c
--- linux-2.6/drivers/s390/cio/qdio.c	2007-01-26 17:27:33.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/qdio.c	2007-01-26 17:27:46.000000000 +0100
@@ -66,7 +66,6 @@ MODULE_LICENSE("GPL");
 /******************** HERE WE GO ***********************************/
 
 static const char version[] = "QDIO base support version 2";
-extern struct bus_type ccw_bus_type;
 
 static int qdio_performance_stats = 0;
 static int proc_perf_file_registration;
@@ -3014,7 +3013,7 @@ qdio_allocate(struct qdio_initialize *in
 	return 0;
 }
 
-int qdio_fill_irq(struct qdio_initialize *init_data)
+static int qdio_fill_irq(struct qdio_initialize *init_data)
 {
 	int i;
 	char dbf_text[15];
diff -urpN linux-2.6/drivers/s390/crypto/zcrypt_api.c linux-2.6-patched/drivers/s390/crypto/zcrypt_api.c
--- linux-2.6/drivers/s390/crypto/zcrypt_api.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/crypto/zcrypt_api.c	2007-01-26 17:27:46.000000000 +0100
@@ -791,7 +791,7 @@ static long trans_xcRB32(struct file *fi
 	return rc;
 }
 
-long zcrypt_compat_ioctl(struct file *filp, unsigned int cmd,
+static long zcrypt_compat_ioctl(struct file *filp, unsigned int cmd,
 			 unsigned long arg)
 {
 	if (cmd == ICARSAMODEXPO)
@@ -943,7 +943,7 @@ static int zcrypt_status_read(char *resp
 	zcrypt_qdepth_mask(workarea);
 	len += sprinthx("Waiting work element counts",
 			resp_buff+len, workarea, AP_DEVICES);
-	zcrypt_perdev_reqcnt((unsigned int *) workarea);
+	zcrypt_perdev_reqcnt((int *) workarea);
 	len += sprinthx4("Per-device successfully completed request counts",
 			 resp_buff+len,(unsigned int *) workarea, AP_DEVICES);
 	*eof = 1;
diff -urpN linux-2.6/drivers/s390/crypto/zcrypt_pcixcc.c linux-2.6-patched/drivers/s390/crypto/zcrypt_pcixcc.c
--- linux-2.6/drivers/s390/crypto/zcrypt_pcixcc.c	2007-01-26 17:27:34.000000000 +0100
+++ linux-2.6-patched/drivers/s390/crypto/zcrypt_pcixcc.c	2007-01-26 17:27:46.000000000 +0100
@@ -709,7 +709,8 @@ out_free:
  *	  PCIXCC/CEX2C device to the request distributor
  * @xcRB: pointer to the send_cprb request buffer
  */
-long zcrypt_pcixcc_send_cprb(struct zcrypt_device *zdev, struct ica_xcRB *xcRB)
+static long zcrypt_pcixcc_send_cprb(struct zcrypt_device *zdev,
+				    struct ica_xcRB *xcRB)
 {
 	struct ap_message ap_msg;
 	struct response_type resp_type = {
diff -urpN linux-2.6/drivers/s390/net/claw.c linux-2.6-patched/drivers/s390/net/claw.c
--- linux-2.6/drivers/s390/net/claw.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/net/claw.c	2007-01-26 17:27:46.000000000 +0100
@@ -121,7 +121,7 @@ MODULE_LICENSE("GPL");
 #define DEBUG
 #endif
 
- char debug_buffer[255];
+static char debug_buffer[255];
 /**
  * Debug Facility Stuff
  */
diff -urpN linux-2.6/drivers/s390/net/cu3088.c linux-2.6-patched/drivers/s390/net/cu3088.c
--- linux-2.6/drivers/s390/net/cu3088.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/net/cu3088.c	2007-01-26 17:27:46.000000000 +0100
@@ -57,7 +57,7 @@ static struct ccw_device_id cu3088_ids[]
 
 static struct ccw_driver cu3088_driver;
 
-struct device *cu3088_root_dev;
+static struct device *cu3088_root_dev;
 
 static ssize_t
 group_write(struct device_driver *drv, const char *buf, size_t count)
diff -urpN linux-2.6/drivers/s390/net/lcs.c linux-2.6-patched/drivers/s390/net/lcs.c
--- linux-2.6/drivers/s390/net/lcs.c	2007-01-26 17:27:34.000000000 +0100
+++ linux-2.6-patched/drivers/s390/net/lcs.c	2007-01-26 17:27:46.000000000 +0100
@@ -828,7 +828,7 @@ lcs_notify_lancmd_waiters(struct lcs_car
 /**
  * Emit buffer of a lan comand.
  */
-void
+static void
 lcs_lancmd_timeout(unsigned long data)
 {
 	struct lcs_reply *reply, *list_reply, *r;
@@ -1360,7 +1360,7 @@ lcs_get_problem(struct ccw_device *cdev,
 	return 0;
 }
 
-void
+static void
 lcs_schedule_recovery(struct lcs_card *card)
 {
 	LCS_DBF_TEXT(2, trace, "startrec");
@@ -1990,7 +1990,7 @@ lcs_timeout_store (struct device *dev, s
 
 }
 
-DEVICE_ATTR(lancmd_timeout, 0644, lcs_timeout_show, lcs_timeout_store);
+static DEVICE_ATTR(lancmd_timeout, 0644, lcs_timeout_show, lcs_timeout_store);
 
 static ssize_t
 lcs_dev_recover_store(struct device *dev, struct device_attribute *attr,
diff -urpN linux-2.6/drivers/s390/net/netiucv.c linux-2.6-patched/drivers/s390/net/netiucv.c
--- linux-2.6/drivers/s390/net/netiucv.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/net/netiucv.c	2007-01-26 17:27:46.000000000 +0100
@@ -2053,7 +2053,7 @@ out_free_ndev:
 	return ret;
 }
 
-DRIVER_ATTR(connection, 0200, NULL, conn_write);
+static DRIVER_ATTR(connection, 0200, NULL, conn_write);
 
 static ssize_t
 remove_write (struct device_driver *drv, const char *buf, size_t count)
@@ -2112,7 +2112,7 @@ remove_write (struct device_driver *drv,
         return -EINVAL;
 }
 
-DRIVER_ATTR(remove, 0200, NULL, remove_write);
+static DRIVER_ATTR(remove, 0200, NULL, remove_write);
 
 static void
 netiucv_banner(void)
diff -urpN linux-2.6/drivers/s390/net/qeth_sys.c linux-2.6-patched/drivers/s390/net/qeth_sys.c
--- linux-2.6/drivers/s390/net/qeth_sys.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/net/qeth_sys.c	2007-01-26 17:27:46.000000000 +0100
@@ -998,7 +998,7 @@ struct device_attribute dev_attr_##_id =
 	.store	= _store,						     \
 };
 
-int
+static int
 qeth_check_layer2(struct qeth_card *card)
 {
 	if (card->options.layer2)
diff -urpN linux-2.6/drivers/s390/s390mach.c linux-2.6-patched/drivers/s390/s390mach.c
--- linux-2.6/drivers/s390/s390mach.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/s390mach.c	2007-01-26 17:27:46.000000000 +0100
@@ -13,22 +13,18 @@
 #include <linux/errno.h>
 #include <linux/workqueue.h>
 #include <linux/time.h>
+#include <linux/device.h>
 #include <linux/kthread.h>
 
 #include <asm/lowcore.h>
-
+#include <asm/cio.h>
+#include "cio/cio.h"
+#include "cio/chsc.h"
+#include "cio/css.h"
 #include "s390mach.h"
 
 static struct semaphore m_sem;
 
-extern int css_process_crw(int, int);
-extern int chsc_process_crw(void);
-extern int chp_process_crw(int, int);
-extern void css_reiterate_subchannels(void);
-
-extern struct workqueue_struct *slow_path_wq;
-extern struct work_struct slow_path_work;
-
 static NORET_TYPE void
 s390_handle_damage(char *msg)
 {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2007-01-26 17:27:46.000000000 +0100
@@ -469,7 +469,7 @@ zfcp_hba_dbf_view_format(debug_info_t * 
 	return len;
 }
 
-struct debug_view zfcp_hba_dbf_view = {
+static struct debug_view zfcp_hba_dbf_view = {
 	"structured",
 	NULL,
 	&zfcp_dbf_view_header,
@@ -693,7 +693,7 @@ zfcp_san_dbf_view_format(debug_info_t * 
 	return len;
 }
 
-struct debug_view zfcp_san_dbf_view = {
+static struct debug_view zfcp_san_dbf_view = {
 	"structured",
 	NULL,
 	&zfcp_dbf_view_header,
@@ -884,7 +884,7 @@ zfcp_scsi_dbf_view_format(debug_info_t *
 	return len;
 }
 
-struct debug_view zfcp_scsi_dbf_view = {
+static struct debug_view zfcp_scsi_dbf_view = {
 	"structured",
 	NULL,
 	&zfcp_dbf_view_header,
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2007-01-26 17:27:46.000000000 +0100
@@ -200,7 +200,7 @@ void zfcp_fsf_start_timer(struct zfcp_fs
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-int
+static int
 zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *adapter, int clear_mask)
 {
 	int retval;
@@ -295,7 +295,7 @@ zfcp_erp_unit_shutdown(struct zfcp_unit 
  * zfcp_erp_adisc - send ADISC ELS command
  * @port: port structure
  */
-int
+static int
 zfcp_erp_adisc(struct zfcp_port *port)
 {
 	struct zfcp_adapter *adapter = port->adapter;
@@ -380,7 +380,7 @@ zfcp_erp_adisc(struct zfcp_port *port)
  *
  * If ADISC failed (LS_RJT or timed out) forced reopen of the port is triggered.
  */
-void
+static void
 zfcp_erp_adisc_handler(unsigned long data)
 {
 	struct zfcp_send_els *send_els;
@@ -3141,7 +3141,6 @@ zfcp_erp_action_cleanup(int action, stru
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (result != ZFCP_ERP_SUCCEEDED) {
-			struct zfcp_port *port;
 			list_for_each_entry(port, &adapter->port_list_head, list)
 				if (port->rport &&
 				    !atomic_test_mask(ZFCP_STATUS_PORT_WKA,
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2007-01-26 17:27:46.000000000 +0100
@@ -119,8 +119,8 @@ extern int  zfcp_adapter_scsi_register(s
 extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
 extern void zfcp_set_fcp_dl(struct fcp_cmnd_iu *, fcp_dl_t);
 extern char *zfcp_get_fcp_rsp_info_ptr(struct fcp_rsp_iu *);
-extern void set_host_byte(u32 *, char);
-extern void set_driver_byte(u32 *, char);
+extern void set_host_byte(int *, char);
+extern void set_driver_byte(int *, char);
 extern char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *);
 extern fcp_dl_t zfcp_get_fcp_dl(struct fcp_cmnd_iu *);
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2007-01-26 17:27:46.000000000 +0100
@@ -90,7 +90,7 @@ zfcp_get_fcp_sns_info_ptr(struct fcp_rsp
 	return fcp_sns_info_ptr;
 }
 
-fcp_dl_t *
+static fcp_dl_t *
 zfcp_get_fcp_dl_ptr(struct fcp_cmnd_iu * fcp_cmd)
 {
 	int additional_length = fcp_cmd->add_fcp_cdb_length << 2;
@@ -124,19 +124,19 @@ zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_
  * regarding the specified byte
  */
 static inline void
-set_byte(u32 * result, char status, char pos)
+set_byte(int *result, char status, char pos)
 {
 	*result |= status << (pos * 8);
 }
 
 void
-set_host_byte(u32 * result, char status)
+set_host_byte(int *result, char status)
 {
 	set_byte(result, status, 2);
 }
 
 void
-set_driver_byte(u32 * result, char status)
+set_driver_byte(int *result, char status)
 {
 	set_byte(result, status, 3);
 }
@@ -280,7 +280,7 @@ out:
 	return retval;
 }
 
-void
+static void
 zfcp_scsi_command_sync_handler(struct scsi_cmnd *scpnt)
 {
 	struct completion *wait = (struct completion *) scpnt->SCp.ptr;
@@ -324,7 +324,7 @@ zfcp_scsi_command_sync(struct zfcp_unit 
  * returns:	0 - success, SCSI command enqueued
  *		!0 - failure
  */
-int
+static int
 zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 		       void (*done) (struct scsi_cmnd *))
 {
@@ -380,7 +380,7 @@ zfcp_unit_lookup(struct zfcp_adapter *ad
  * will handle late commands.  (Usually, the normal completion of late
  * commands is ignored with respect to the running abort operation.)
  */
-int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
  	struct Scsi_Host *scsi_host;
  	struct zfcp_adapter *adapter;
@@ -445,7 +445,7 @@ int zfcp_scsi_eh_abort_handler(struct sc
 	return retval;
 }
 
-int
+static int
 zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 {
 	int retval;
@@ -541,7 +541,7 @@ zfcp_task_management_function(struct zfc
 /**
  * zfcp_scsi_eh_host_reset_handler - handler for host and bus reset
  */
-int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
 	struct zfcp_unit *unit;
 	struct zfcp_adapter *adapter;
diff -urpN linux-2.6/include/asm-s390/kdebug.h linux-2.6-patched/include/asm-s390/kdebug.h
--- linux-2.6/include/asm-s390/kdebug.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/kdebug.h	2007-01-26 17:27:46.000000000 +0100
@@ -26,7 +26,6 @@ extern int register_page_fault_notifier(
 extern int unregister_page_fault_notifier(struct notifier_block *);
 extern struct atomic_notifier_head s390die_chain;
 
-
 enum die_val {
 	DIE_OOPS = 1,
 	DIE_BPT,
@@ -56,4 +55,6 @@ static inline int notify_die(enum die_va
 	return atomic_notifier_call_chain(&s390die_chain, val, &args);
 }
 
+extern void die(const char *, struct pt_regs *, long);
+
 #endif
diff -urpN linux-2.6/include/asm-s390/pgtable.h linux-2.6-patched/include/asm-s390/pgtable.h
--- linux-2.6/include/asm-s390/pgtable.h	2007-01-26 17:27:36.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/pgtable.h	2007-01-26 17:27:46.000000000 +0100
@@ -40,6 +40,7 @@ struct mm_struct;
 
 extern pgd_t swapper_pg_dir[] __attribute__ ((aligned (4096)));
 extern void paging_init(void);
+extern void vmem_map_init(void);
 
 /*
  * The S390 doesn't have any external MMU info: the kernel page
diff -urpN linux-2.6/include/asm-s390/setup.h linux-2.6-patched/include/asm-s390/setup.h
--- linux-2.6/include/asm-s390/setup.h	2007-01-26 17:27:36.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/setup.h	2007-01-26 17:27:46.000000000 +0100
@@ -74,6 +74,9 @@ extern unsigned int console_mode;
 extern unsigned int console_devno;
 extern unsigned int console_irq;
 
+extern char vmhalt_cmd[];
+extern char vmpoff_cmd[];
+
 #define CONSOLE_IS_UNDEFINED	(console_mode == 0)
 #define CONSOLE_IS_SCLP		(console_mode == 1)
 #define CONSOLE_IS_3215		(console_mode == 2)
diff -urpN linux-2.6/include/asm-s390/smp.h linux-2.6-patched/include/asm-s390/smp.h
--- linux-2.6/include/asm-s390/smp.h	2007-01-26 17:27:36.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/smp.h	2007-01-26 17:27:46.000000000 +0100
@@ -31,6 +31,10 @@ typedef struct
 	__u16      cpu;
 } sigp_info;
 
+extern void machine_restart_smp(char *);
+extern void machine_halt_smp(void);
+extern void machine_power_off_smp(void);
+
 extern void smp_setup_cpu_possible_map(void);
 extern int smp_call_function_on(void (*func) (void *info), void *info,
 				int nonatomic, int wait, int cpu);
diff -urpN linux-2.6/include/asm-s390/timer.h linux-2.6-patched/include/asm-s390/timer.h
--- linux-2.6/include/asm-s390/timer.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/timer.h	2007-01-26 17:27:46.000000000 +0100
@@ -45,6 +45,9 @@ extern void add_virt_timer_periodic(void
 extern int mod_virt_timer(struct vtimer_list *timer, __u64 expires);
 extern int del_virt_timer(struct vtimer_list *timer);
 
+extern void init_cpu_vtimer(void);
+extern void vtime_init(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_S390_TIMER_H */
diff -urpN linux-2.6/include/asm-s390/timex.h linux-2.6-patched/include/asm-s390/timex.h
--- linux-2.6/include/asm-s390/timex.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/timex.h	2007-01-26 17:27:46.000000000 +0100
@@ -32,4 +32,6 @@ static inline cycles_t get_cycles(void)
 	return (cycles_t) get_clock() >> 2;
 }
 
+void init_cpu_timer(void);
+
 #endif
