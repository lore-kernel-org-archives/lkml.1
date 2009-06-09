Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZFIGho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZFIGho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbZFIGh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:37:28 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58198 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564AbZFIGh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:37:26 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 16/27] score: create head files scatterlist.h scoreregs.h sections.h
 segment.h sembuf.h setup.h shmbuf.h shmparam.h sigcontext.h siginfo.h
 signal.h socket.h sockios.h statfs.h stat.h string.h swab.h syscalls.h
 system.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF6E98041E.B5C6A199-ON482575D0.0023E412-482575D0.00245A53@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:32:46 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:32:47,
	Serialize complete at 2009/06/09 ?? 02:32:47
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1a9b8306208068d0967894a6e9fb1fbdecd84bed Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:13 +0800
Subject: [PATCH 16/27] score: create head files scatterlist.h scoreregs.h 
sections.h segment.h sembuf.h setup.h shmbuf.h shmparam.h sigcontext.h 
siginfo.h signal.h socket.h sockios.h statfs.h stat.h string.h swab.h 
syscalls.h system.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/scatterlist.h |    6 ++
 arch/score/include/asm/scoreregs.h   |   51 +++++++++++++++++++
 arch/score/include/asm/sections.h    |    6 ++
 arch/score/include/asm/segment.h     |   21 ++++++++
 arch/score/include/asm/sembuf.h      |    6 ++
 arch/score/include/asm/setup.h       |   40 +++++++++++++++
 arch/score/include/asm/shmbuf.h      |    6 ++
 arch/score/include/asm/shmparam.h    |    6 ++
 arch/score/include/asm/sigcontext.h  |   22 ++++++++
 arch/score/include/asm/siginfo.h     |    6 ++
 arch/score/include/asm/signal.h      |    6 ++
 arch/score/include/asm/socket.h      |    6 ++
 arch/score/include/asm/sockios.h     |    6 ++
 arch/score/include/asm/stat.h        |    6 ++
 arch/score/include/asm/statfs.h      |    6 ++
 arch/score/include/asm/string.h      |    8 +++
 arch/score/include/asm/swab.h        |    6 ++
 arch/score/include/asm/syscalls.h    |    9 +++
 arch/score/include/asm/system.h      |   90 
++++++++++++++++++++++++++++++++++
 19 files changed, 313 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/scatterlist.h
 create mode 100644 arch/score/include/asm/scoreregs.h
 create mode 100644 arch/score/include/asm/sections.h
 create mode 100644 arch/score/include/asm/segment.h
 create mode 100644 arch/score/include/asm/sembuf.h
 create mode 100644 arch/score/include/asm/setup.h
 create mode 100644 arch/score/include/asm/shmbuf.h
 create mode 100644 arch/score/include/asm/shmparam.h
 create mode 100644 arch/score/include/asm/sigcontext.h
 create mode 100644 arch/score/include/asm/siginfo.h
 create mode 100644 arch/score/include/asm/signal.h
 create mode 100644 arch/score/include/asm/socket.h
 create mode 100644 arch/score/include/asm/sockios.h
 create mode 100644 arch/score/include/asm/stat.h
 create mode 100644 arch/score/include/asm/statfs.h
 create mode 100644 arch/score/include/asm/string.h
 create mode 100644 arch/score/include/asm/swab.h
 create mode 100644 arch/score/include/asm/syscalls.h
 create mode 100644 arch/score/include/asm/system.h

diff --git a/arch/score/include/asm/scatterlist.h 
b/arch/score/include/asm/scatterlist.h
new file mode 100644
index 0000000..9f533b8
--- /dev/null
+++ b/arch/score/include/asm/scatterlist.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SCATTERLIST_H
+#define _ASM_SCORE_SCATTERLIST_H
+
+#include <asm-generic/scatterlist.h>
+
+#endif /* _ASM_SCORE_SCATTERLIST_H */
diff --git a/arch/score/include/asm/scoreregs.h 
b/arch/score/include/asm/scoreregs.h
new file mode 100644
index 0000000..d0ad292
--- /dev/null
+++ b/arch/score/include/asm/scoreregs.h
@@ -0,0 +1,51 @@
+#ifndef _ASM_SCORE_SCOREREGS_H
+#define _ASM_SCORE_SCOREREGS_H
+
+#include <linux/linkage.h>
+
+/* TIMER register */
+#define TIME0BASE              0x96080000
+#define P_TIMER0_CTRL          (TIME0BASE + 0x00)
+#define P_TIMER0_CPP_CTRL      (TIME0BASE + 0x04)
+#define P_TIMER0_PRELOAD       (TIME0BASE + 0x08)
+#define P_TIMER0_CPP_REG       (TIME0BASE + 0x0C)
+#define P_TIMER0_UPCNT         (TIME0BASE + 0x10)
+
+/* Timer Controller Register */
+/* bit 0 Timer enable */
+#define TMR_DISABLE    0x0000
+#define TMR_ENABLE     0x0001
+
+/* bit 1 Interrupt enable */
+#define TMR_IE_DISABLE 0x0000
+#define TMR_IE_ENABLE  0x0002
+
+/* bit 2 Output enable */
+#define TMR_OE_DISABLE 0x0004
+#define TMR_OE_ENABLE  0x0000
+
+/* bit4 Up/Down counting selection */
+#define TMR_UD_DOWN    0x0000
+#define TMR_UD_UP      0x0010
+
+/* bit5 Up/Down counting control selection */
+#define TMR_UDS_UD     0x0000
+#define TMR_UDS_EXTUD  0x0020
+
+/* bit6 Time output mode */
+#define TMR_OM_TOGGLE  0x0000
+#define TMR_OM_PILSE   0x0040
+
+/* bit 8..9 External input active edge selection */
+#define TMR_ES_PE      0x0000
+#define TMR_ES_NE      0x0100
+#define TMR_ES_BOTH    0x0200
+
+/* bit 10..11 Operating mode */
+#define TMR_M_FREE     0x0000 /* free running timer mode */
+#define TMR_M_PERIODIC 0x0400 /* periodic timer mode */
+#define TMR_M_FC       0x0800 /* free running counter mode */
+#define TMR_M_PC       0x0c00 /* periodic counter mode */
+
+#define SYSTEM_CLOCK           (27*1000000/4)          /* 27 MHz */
+#endif /* _ASM_SCORE_SCOREREGS_H */
diff --git a/arch/score/include/asm/sections.h 
b/arch/score/include/asm/sections.h
new file mode 100644
index 0000000..9441d23
--- /dev/null
+++ b/arch/score/include/asm/sections.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SECTIONS_H
+#define _ASM_SCORE_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+#endif /* _ASM_SCORE_SECTIONS_H */
diff --git a/arch/score/include/asm/segment.h 
b/arch/score/include/asm/segment.h
new file mode 100644
index 0000000..e16cf6a
--- /dev/null
+++ b/arch/score/include/asm/segment.h
@@ -0,0 +1,21 @@
+#ifndef _ASM_SCORE_SEGMENT_H
+#define _ASM_SCORE_SEGMENT_H
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+       unsigned long seg;
+} mm_segment_t;
+
+#define KERNEL_DS      ((mm_segment_t){0})
+#define USER_DS        KERNEL_DS
+
+# define get_ds()      (KERNEL_DS)
+# define get_fs()      (current_thread_info()->addr_limit)
+# define set_fs(x)     \
+       do { current_thread_info()->addr_limit = (x); } while (0)
+
+# define segment_eq(a, b)      ((a).seg == (b).seg)
+
+# endif /* __ASSEMBLY__ */
+#endif /* _ASM_SCORE_SEGMENT_H */
diff --git a/arch/score/include/asm/sembuf.h 
b/arch/score/include/asm/sembuf.h
new file mode 100644
index 0000000..dae5e83
--- /dev/null
+++ b/arch/score/include/asm/sembuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SEMBUF_H
+#define _ASM_SCORE_SEMBUF_H
+
+#include <asm-generic/sembuf.h>
+
+#endif /* _ASM_SCORE_SEMBUF_H */
diff --git a/arch/score/include/asm/setup.h 
b/arch/score/include/asm/setup.h
new file mode 100644
index 0000000..de89eff
--- /dev/null
+++ b/arch/score/include/asm/setup.h
@@ -0,0 +1,40 @@
+#ifndef _ASM_SCORE_SETUP_H
+#define _ASM_SCORE_SETUP_H
+
+#define COMMAND_LINE_SIZE      256
+#define MEM_SIZE               0x2000000
+
+#ifdef __KERNEL__
+
+extern void pagetable_init(void);
+extern void pgd_init(unsigned long page);
+
+extern void setup_early_printk(void);
+extern void cpu_cache_init(void);
+extern void tlb_init(void);
+
+extern void handle_nmi(void);
+extern void handle_adelinsn(void);
+extern void handle_adedata(void);
+extern void handle_ibe(void);
+extern void handle_pel(void);
+extern void handle_sys(void);
+extern void handle_ccu(void);
+extern void handle_ri(void);
+extern void handle_tr(void);
+extern void handle_ades(void);
+extern void handle_cee(void);
+extern void handle_cpe(void);
+extern void handle_dve(void);
+extern void handle_dbe(void);
+extern void handle_reserved(void);
+extern void handle_tlb_refill(void);
+extern void handle_tlb_invaild(void);
+extern void handle_mod(void);
+extern void debug_exception_vector(void);
+extern void general_exception_vector(void);
+extern void interrupt_exception_vector(void);
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SCORE_SETUP_H */
diff --git a/arch/score/include/asm/shmbuf.h 
b/arch/score/include/asm/shmbuf.h
new file mode 100644
index 0000000..c85b242
--- /dev/null
+++ b/arch/score/include/asm/shmbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SHMBUF_H
+#define _ASM_SCORE_SHMBUF_H
+
+#include <asm-generic/shmbuf.h>
+
+#endif /* _ASM_SCORE_SHMBUF_H */
diff --git a/arch/score/include/asm/shmparam.h 
b/arch/score/include/asm/shmparam.h
new file mode 100644
index 0000000..1d60813
--- /dev/null
+++ b/arch/score/include/asm/shmparam.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SHMPARAM_H
+#define _ASM_SCORE_SHMPARAM_H
+
+#include <asm-generic/shmparam.h>
+
+#endif /* _ASM_SCORE_SHMPARAM_H */
diff --git a/arch/score/include/asm/sigcontext.h 
b/arch/score/include/asm/sigcontext.h
new file mode 100644
index 0000000..5ffda39
--- /dev/null
+++ b/arch/score/include/asm/sigcontext.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_SCORE_SIGCONTEXT_H
+#define _ASM_SCORE_SIGCONTEXT_H
+
+/*
+ * Keep this struct definition in sync with the sigcontext fragment
+ * in arch/score/tools/offset.c
+ */
+struct sigcontext {
+       unsigned int            sc_regmask;
+       unsigned int            sc_psr;
+       unsigned int            sc_condition;
+       unsigned long           sc_pc;
+       unsigned long           sc_regs[32];
+       unsigned int            sc_ssflags;
+       unsigned int            sc_mdceh;
+       unsigned int            sc_mdcel;
+       unsigned int            sc_ecr;
+       unsigned long           sc_ema;
+       unsigned long           sc_sigset[4];
+};
+
+#endif /* _ASM_SCORE_SIGCONTEXT_H */
diff --git a/arch/score/include/asm/siginfo.h 
b/arch/score/include/asm/siginfo.h
new file mode 100644
index 0000000..87ca356
--- /dev/null
+++ b/arch/score/include/asm/siginfo.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SIGINFO_H
+#define _ASM_SCORE_SIGINFO_H
+
+#include <asm-generic/siginfo.h>
+
+#endif /* _ASM_SCORE_SIGINFO_H */
diff --git a/arch/score/include/asm/signal.h 
b/arch/score/include/asm/signal.h
new file mode 100644
index 0000000..2605bc0
--- /dev/null
+++ b/arch/score/include/asm/signal.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SIGNAL_H
+#define _ASM_SCORE_SIGNAL_H
+
+#include <asm-generic/signal.h>
+
+#endif /* _ASM_SCORE_SIGNAL_H */
diff --git a/arch/score/include/asm/socket.h 
b/arch/score/include/asm/socket.h
new file mode 100644
index 0000000..612a70e
--- /dev/null
+++ b/arch/score/include/asm/socket.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SOCKET_H
+#define _ASM_SCORE_SOCKET_H
+
+#include <asm-generic/socket.h>
+
+#endif /* _ASM_SCORE_SOCKET_H */
diff --git a/arch/score/include/asm/sockios.h 
b/arch/score/include/asm/sockios.h
new file mode 100644
index 0000000..ba82564
--- /dev/null
+++ b/arch/score/include/asm/sockios.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SOCKIOS_H
+#define _ASM_SCORE_SOCKIOS_H
+
+#include <asm-generic/sockios.h>
+
+#endif /* _ASM_SCORE_SOCKIOS_H */
diff --git a/arch/score/include/asm/stat.h b/arch/score/include/asm/stat.h
new file mode 100644
index 0000000..5037055
--- /dev/null
+++ b/arch/score/include/asm/stat.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_STAT_H
+#define _ASM_SCORE_STAT_H
+
+#include <asm-generic/stat.h>
+
+#endif /* _ASM_SCORE_STAT_H */
diff --git a/arch/score/include/asm/statfs.h 
b/arch/score/include/asm/statfs.h
new file mode 100644
index 0000000..36e4100
--- /dev/null
+++ b/arch/score/include/asm/statfs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_STATFS_H
+#define _ASM_SCORE_STATFS_H
+
+#include <asm-generic/statfs.h>
+
+#endif /* _ASM_SCORE_STATFS_H */
diff --git a/arch/score/include/asm/string.h 
b/arch/score/include/asm/string.h
new file mode 100644
index 0000000..8a6bf50
--- /dev/null
+++ b/arch/score/include/asm/string.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_SCORE_STRING_H
+#define _ASM_SCORE_STRING_H
+
+extern void *memset(void *__s, int __c, size_t __count);
+extern void *memcpy(void *__to, __const__ void *__from, size_t __n);
+extern void *memmove(void *__dest, __const__ void *__src, size_t __n);
+
+#endif /* _ASM_SCORE_STRING_H */
diff --git a/arch/score/include/asm/swab.h b/arch/score/include/asm/swab.h
new file mode 100644
index 0000000..fadc3cc
--- /dev/null
+++ b/arch/score/include/asm/swab.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SWAB_H
+#define _ASM_SCORE_SWAB_H
+
+#include <asm-generic/swab.h>
+
+#endif /* _ASM_SCORE_SWAB_H */
diff --git a/arch/score/include/asm/syscalls.h 
b/arch/score/include/asm/syscalls.h
new file mode 100644
index 0000000..00c28e0
--- /dev/null
+++ b/arch/score/include/asm/syscalls.h
@@ -0,0 +1,9 @@
+#ifndef _ASM_SCORE_SYSCALLS_H
+#define _ASM_SCORE_SYSCALLS_H
+
+asmlinkage long sys_clone(int flags, unsigned long stack, struct pt_regs 
*regs);
+#define sys_clone sys_clone
+
+#include <asm-generic/syscalls.h>
+
+#endif /* _ASM_SCORE_SYSCALLS_H */
diff --git a/arch/score/include/asm/system.h 
b/arch/score/include/asm/system.h
new file mode 100644
index 0000000..589d5c7
--- /dev/null
+++ b/arch/score/include/asm/system.h
@@ -0,0 +1,90 @@
+#ifndef _ASM_SCORE_SYSTEM_H
+#define _ASM_SCORE_SYSTEM_H
+
+#include <linux/types.h>
+#include <linux/irqflags.h>
+
+struct pt_regs;
+struct task_struct;
+
+extern void *resume(void *last, void *next, void *next_ti);
+
+#define switch_to(prev, next, last)                            \
+do {                                                           \
+       (last) = resume(prev, next, task_thread_info(next));    \
+} while (0)
+
+#define finish_arch_switch(prev)       do {} while (0)
+
+typedef void (*vi_handler_t)(void);
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#define mb()           barrier()
+#define rmb()          barrier()
+#define wmb()          barrier()
+#define smp_mb()       barrier()
+#define smp_rmb()      barrier()
+#define smp_wmb()      barrier()
+
+#define read_barrier_depends()         do {} while (0)
+#define smp_read_barrier_depends()     do {} while (0)
+
+#define set_mb(var, value)             do {var = value; wmb(); } while 
(0)
+
+#define __HAVE_ARCH_CMPXCHG    1
+
+#include <asm-generic/cmpxchg-local.h>
+
+#ifndef __ASSEMBLY__
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+static inline
+unsigned long __xchg(volatile unsigned long *m, unsigned long val)
+{
+       unsigned long retval;
+       unsigned long flags;
+
+       local_irq_save(flags);
+       retval = *m;
+       *m = val;
+       local_irq_restore(flags);
+       return retval;
+}
+
+#define xchg(ptr, v)                                           \
+       ((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),    \
+                                       (unsigned long)(v)))
+
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+                               unsigned long old, unsigned long new)
+{
+       unsigned long retval;
+       unsigned long flags;
+
+       local_irq_save(flags);
+       retval = *m;
+       if (retval == old)
+               *m = new;
+       local_irq_restore(flags);
+       return retval;
+}
+
+#define cmpxchg(ptr, o, n)                                     \
+       ((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
+                                       (unsigned long)(o),     \
+                                       (unsigned long)(n)))
+
+extern void __die(const char *, struct pt_regs *, const char *,
+       const char *, unsigned long) __attribute__((noreturn));
+extern void __die_if_kernel(const char *, struct pt_regs *, const char *,
+       const char *, unsigned long);
+
+#define die(msg, regs)                                                 \
+       __die(msg, regs, __FILE__ ":", __func__, __LINE__)
+#define die_if_kernel(msg, regs)                                       \
+       __die_if_kernel(msg, regs, __FILE__ ":", __func__, __LINE__)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_SCORE_SYSTEM_H */
-- 
1.6.2

