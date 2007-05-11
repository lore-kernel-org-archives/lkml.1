Return-Path: <linux-kernel-owner+w=401wt.eu-S1031391AbXEKTvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031391AbXEKTvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbXEKTny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:43:54 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45988 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760533AbXEKTnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:43:52 -0400
Message-ID: <4644C773.304@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:43:47 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/um/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/um/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/um/drivers/line.c           |    2 +-
 arch/um/drivers/null.c           |    2 +-
 arch/um/drivers/stderr_console.c |    2 +-
 arch/um/kernel/gmon_syms.c       |    4 ++--
 arch/um/kernel/irq.c             |    2 +-
 arch/um/kernel/ptrace.c          |    2 +-
 arch/um/sys-i386/bug.c           |    2 +-
 arch/um/sys-i386/tls.c           |    2 +-
 arch/um/sys-x86_64/bug.c         |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index ced9910..378d77b 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -41,7 +41,7 @@ static void line_timer_cb(struct work_struct *work)
 
 /* Returns the free space inside the ring buffer of this line.
  *
- * Should be called while holding line->lock (this does not modify datas).
+ * Should be called while holding line->lock (this does not modify data).
  */
 static int write_room(struct line *line)
 {
diff --git a/arch/um/drivers/null.c b/arch/um/drivers/null.c
index 9016c68..2f7fa51 100644
--- a/arch/um/drivers/null.c
+++ b/arch/um/drivers/null.c
@@ -8,7 +8,7 @@
 #include "chan_user.h"
 #include "os.h"
 
-/* This address is used only as a unique identifer */
+/* This address is used only as a unique identifier */
 static int null_chan;
 
 static void *null_init(char *str, int device, const struct chan_opts *opts)
diff --git a/arch/um/drivers/stderr_console.c b/arch/um/drivers/stderr_console.c
index 9115392..5e8a0ba 100644
--- a/arch/um/drivers/stderr_console.c
+++ b/arch/um/drivers/stderr_console.c
@@ -7,7 +7,7 @@
 /* trivial console driver -- simply dump everything to stderr                    */
 
 /*
- * Don't register by default -- as this registeres very early in the
+ * Don't register by default -- as this registers very early in the
  * boot process it becomes the default console.
  *
  * Initialized at init time.
diff --git a/arch/um/kernel/gmon_syms.c b/arch/um/kernel/gmon_syms.c
index 13aa115..734f873 100644
--- a/arch/um/kernel/gmon_syms.c
+++ b/arch/um/kernel/gmon_syms.c
@@ -12,8 +12,8 @@ EXPORT_SYMBOL(__bb_init_func);
  * versions in libgcov.
  *
  * Since SuSE backported the fix, we cannot handle it depending on GCC version.
- * So, unconditinally export it. But also give it a weak declaration, which will
- * be overriden by any other one.
+ * So, unconditionally export it. But also give it a weak declaration, which will
+ * be overridden by any other one.
  */
 
 extern void __gcov_init(void *) __attribute__((weak));
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 8f2ed36..ba11446 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -364,7 +364,7 @@ void forward_interrupts(int pid)
 #endif
 
 /*
- * do_IRQ handles all normal device IRQ's (the special
+ * do_IRQ handles all normal device IRQs (the special
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 627742d..7b7b584 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -268,7 +268,7 @@ void send_sigtrap(struct task_struct *tsk, union uml_pt_regs *regs,
 	/* User-mode eip? */
 	info.si_addr = UPT_IS_USER(regs) ? (void __user *) UPT_IP(regs) : NULL;
 
-	/* Send us the fakey SIGTRAP */
+	/* Send us the fake SIGTRAP */
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
diff --git a/arch/um/sys-i386/bug.c b/arch/um/sys-i386/bug.c
index 200c8ba..a4360b5 100644
--- a/arch/um/sys-i386/bug.c
+++ b/arch/um/sys-i386/bug.c
@@ -6,7 +6,7 @@
 #include <linux/uaccess.h>
 
 /* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
- * that's not relevent in skas mode.
+ * that's not relevant in skas mode.
  */
 
 int is_valid_bugaddr(unsigned long eip)
diff --git a/arch/um/sys-i386/tls.c b/arch/um/sys-i386/tls.c
index fea8e5e..719fa12 100644
--- a/arch/um/sys-i386/tls.c
+++ b/arch/um/sys-i386/tls.c
@@ -60,7 +60,7 @@ int do_get_thread_area_skas(struct user_desc *info)
  * XXX: Consider leaving one free slot for glibc usage at first place. This must
  * be done here (and by changing GDT_ENTRY_TLS_* macros) and nowhere else.
  *
- * Also, this must be tested when compiling in SKAS mode with dinamic linking
+ * Also, this must be tested when compiling in SKAS mode with dynamic linking
  * and running against NPTL.
  */
 static int get_free_idx(struct task_struct* task)
diff --git a/arch/um/sys-x86_64/bug.c b/arch/um/sys-x86_64/bug.c
index 200c8ba..a4360b5 100644
--- a/arch/um/sys-x86_64/bug.c
+++ b/arch/um/sys-x86_64/bug.c
@@ -6,7 +6,7 @@
 #include <linux/uaccess.h>
 
 /* Mostly copied from i386/x86_86 - eliminated the eip < PAGE_OFFSET because
- * that's not relevent in skas mode.
+ * that's not relevant in skas mode.
  */
 
 int is_valid_bugaddr(unsigned long eip)
-- 
1.5.0.1


-- 
Simon Arlott
