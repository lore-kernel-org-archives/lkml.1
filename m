Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZC1RRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZC1RRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZC1RRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:17:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:54489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZC1RRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:17:08 -0400
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, suresh.b.siddha@intel.com
In-Reply-To: <1238258883.2526.24.camel@ht.satnam>
References: <1238251730.2526.2.camel@ht.satnam>
	 <20090328150745.GC31080@8bytes.org>  <1238258883.2526.24.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 22:46:16 +0530
Message-Id: <1238260576.2526.30.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 22:18 +0530, Jaswinder Singh Rajput wrote:
> On Sat, 2009-03-28 at 16:07 +0100, Joerg Roedel wrote:
> > On Sat, Mar 28, 2009 at 08:18:50PM +0530, Jaswinder Singh Rajput wrote:
> > > The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
> > >   Ingo Molnar (1):
> > >         Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> > > 
> > > Jaswinder Singh Rajput (49):
> > >       x86: process_32.c include inverse Xmas tree effect
> > >       x86: signal.c include inverse Xmas tree effect
> > >       x86: entry_32.S include inverse Xmas tree effect
> > >       x86: traps.c include inverse Xmas tree effect
> > >       x86: irq.c include inverse Xmas tree effect
> > >       x86: irq_32.c include inverse Xmas tree effect
> > >       x86: dumpstack.c include inverse Xmas tree effect
> > >       x86: time_32.c include inverse Xmas tree effect
> > >       x86: ioport.c include inverse Xmas tree effect
> > >       x86: ldt.c include inverse Xmas tree effect
> > >       x86: dumpstack_32.c include inverse Xmas tree effect
> > >       x86: setup.c include inverse Xmas tree effect
> > >       x86: i8259.c include inverse Xmas tree effect
> > >       x86: irqinit_32.c include inverse Xmas tree effect
> > >       x86: probe_roms_32.c include inverse Xmas tree effect
> > >       x86: sys_i386_32.c include inverse Xmas tree effect
> > >       x86: i386_ksyms_32.c include inverse Xmas tree effect
> > >       x86: bootflag.c include inverse Xmas tree effect
> > >       x86: e820.c include inverse Xmas tree effect
> > >       x86: pci-dma.c include inverse Xmas tree effect
> > >       x86: quirks.c include inverse Xmas tree effect
> > >       x86: i8237.c include inverse Xmas tree effect
> > >       x86: alternative.c include inverse Xmas tree effect
> > >       x86: tsc.c include inverse Xmas tree effect
> > >       x86: process.c include inverse Xmas tree effect
> > >       x86: xsave.c include inverse Xmas tree effect
> > >       x86: ptrace.c include inverse Xmas tree effect
> > >       x86: ds.c include inverse Xmas tree effect
> > >       x86: tls.c include inverse Xmas tree effect
> > >       x86: step.c include inverse Xmas tree effect
> > >       x86: stacktrace.c include inverse Xmas tree effect
> > >       x86: reboot.c include inverse Xmas tree effect
> > >       x86: msr.c include inverse Xmas tree effect
> > >       x86: cpuid.c include inverse Xmas tree effect
> > >       x86: early-quirks.c include inverse Xmas tree effect
> > >       x86: smp.c include inverse Xmas tree effect
> > >       x86: smpboot.c include inverse Xmas tree effect
> > >       x86: tsc_sync.c include inverse Xmas tree effect
> > >       x86: setup_percpu.c include inverse Xmas tree effect
> > >       x86: trampoline_32.S include inverse Xmas tree effect
> > >       x86: mpparse.c include inverse Xmas tree effect
> > >       x86: module_32.c include inverse Xmas tree effect
> > >       x86: doublefault_32.c include inverse Xmas tree effect
> > >       x86: vm86_32.c include inverse Xmas tree effect
> > >       ix86: early_printk.c include inverse Xmas tree effect
> > >       x86: pcspeaker.c include inverse Xmas tree effect
> > >       x86: head_32.c include inverse Xmas tree effect
> > >       x86: head.c include inverse Xmas tree effect
> > >       x86: init_task.c include inverse Xmas tree effect
> > 
> > Where have you sent these patches for review?
> > 
> 
> -tip's master.
> 
> > > Complete diff:
> > 
> > No. Complete diffs are not easy to review. At least not in this size.
> 
> 46 of 49 are clean patches, and only 3 are doubtful which you pointed. I
> am attaching those patches for feedback.
> 

Ahh here is one more:

> > 
> > > diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
> > > index 49fb3ec..a8d63be 100644
> > > --- a/arch/x86/include/asm/proto.h
> > > +++ b/arch/x86/include/asm/proto.h
> > > @@ -7,7 +7,9 @@
> > >  
> > >  extern void early_idt_handler(void);
> > >  
> > > +#ifdef CONFIG_X86_64
> > >  extern void system_call(void);
> > > +#endif
> > >  extern void syscall_init(void);
> > >  
> > >  extern void ia32_syscall(void);

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sat, 28 Mar 2009 14:12:34 +0530
Subject: [PATCH] x86: traps.c include inverse Xmas tree effect

Impact: Xmas tree effect

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/proto.h |    2 ++
 arch/x86/kernel/traps.c      |   34 +++++++++++-----------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 49fb3ec..a8d63be 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -7,7 +7,9 @@
 
 extern void early_idt_handler(void);
 
+#ifdef CONFIG_X86_64
 extern void system_call(void);
+#endif
 extern void syscall_init(void);
 
 extern void ia32_syscall(void);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..4f1e6cf 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
+#include <linux/ioport.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -25,47 +26,34 @@
 #include <linux/kexec.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
+#include <linux/edac.h>
+#include <linux/eisa.h>
 #include <linux/init.h>
 #include <linux/bug.h>
+#include <linux/mca.h>
 #include <linux/nmi.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/io.h>
 
-#ifdef CONFIG_EISA
-#include <linux/ioport.h>
-#include <linux/eisa.h>
-#endif
-
-#ifdef CONFIG_MCA
-#include <linux/mca.h>
-#endif
-
-#if defined(CONFIG_EDAC)
-#include <linux/edac.h>
-#endif
-
+#include <asm/processor-flags.h>
+#include <asm/mach_traps.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
+#include <asm/pgalloc.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
-#include <asm/traps.h>
-#include <asm/desc.h>
-#include <asm/i387.h>
-
-#include <asm/mach_traps.h>
-
-#ifdef CONFIG_X86_64
-#include <asm/pgalloc.h>
 #include <asm/proto.h>
-#else
-#include <asm/processor-flags.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
+#include <asm/desc.h>
+#include <asm/i387.h>
 
 #include "cpu/mcheck/mce.h"
 
+#ifndef CONFIG_X86_64
+
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
-- 
1.6.0.6


> > > diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
> > > index ad1478c..f80df2e 100644
> > > --- a/arch/x86/include/asm/sigcontext32.h
> > > +++ b/arch/x86/include/asm/sigcontext32.h
> > > @@ -1,6 +1,7 @@
> > >  #ifndef _ASM_X86_SIGCONTEXT32_H
> > >  #define _ASM_X86_SIGCONTEXT32_H
> > >  
> > > +#ifdef CONFIG_IA32_EMULATION
> > >  #include <linux/types.h>
> > >  
> > >  /* signal context for 32bit programs. */
> > > @@ -73,5 +74,5 @@ struct sigcontext_ia32 {
> > >         unsigned int oldmask;
> > >         unsigned int cr2;
> > >  };
> > > -
> > > +#endif
> > >  #endif /* _ASM_X86_SIGCONTEXT32_H */
> > 
> > This doesn't seem to be related to your header include rearangements.
> > 
> 
> Please check this patch then you will find the relation:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Sat, 28 Mar 2009 16:02:42 +0530
> Subject: [PATCH] x86: xsave.c include inverse Xmas tree effect
> 
> Impact: Xmas tree effect
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/sigcontext32.h |    3 ++-
>  arch/x86/kernel/xsave.c             |    5 ++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
> index ad1478c..f80df2e 100644
> --- a/arch/x86/include/asm/sigcontext32.h
> +++ b/arch/x86/include/asm/sigcontext32.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_X86_SIGCONTEXT32_H
>  #define _ASM_X86_SIGCONTEXT32_H
>  
> +#ifdef CONFIG_IA32_EMULATION
>  #include <linux/types.h>
>  
>  /* signal context for 32bit programs. */
> @@ -73,5 +74,5 @@ struct sigcontext_ia32 {
>         unsigned int oldmask;
>         unsigned int cr2;
>  };
> -
> +#endif
>  #endif /* _ASM_X86_SIGCONTEXT32_H */
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index 2b54fe0..778ed67 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -3,12 +3,11 @@
>   *
>   * Author: Suresh Siddha <suresh.b.siddha@intel.com>
>   */
> +
> +#include <asm/sigcontext32.h>
>  #include <linux/bootmem.h>
>  #include <linux/compat.h>
>  #include <asm/i387.h>
> -#ifdef CONFIG_IA32_EMULATION
> -#include <asm/sigcontext32.h>
> -#endif
>  #include <asm/xcr.h>
>  
>  /*
> -- 
> 1.6.0.6

this one looks much better:

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sat, 28 Mar 2009 16:02:42 +0530
Subject: [PATCH] x86: xsave.c include inverse Xmas tree effect

Impact: Xmas tree effect

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/sigcontext32.h |    3 ++-
 arch/x86/kernel/xsave.c             |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
index ad1478c..f80df2e 100644
--- a/arch/x86/include/asm/sigcontext32.h
+++ b/arch/x86/include/asm/sigcontext32.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_SIGCONTEXT32_H
 #define _ASM_X86_SIGCONTEXT32_H
 
+#ifdef CONFIG_IA32_EMULATION
 #include <linux/types.h>
 
 /* signal context for 32bit programs. */
@@ -73,5 +74,5 @@ struct sigcontext_ia32 {
        unsigned int oldmask;
        unsigned int cr2;
 };
-
+#endif
 #endif /* _ASM_X86_SIGCONTEXT32_H */
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2b54fe0..f3ce183 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -3,12 +3,12 @@
  *
  * Author: Suresh Siddha <suresh.b.siddha@intel.com>
  */
+
 #include <linux/bootmem.h>
 #include <linux/compat.h>
-#include <asm/i387.h>
-#ifdef CONFIG_IA32_EMULATION
+
 #include <asm/sigcontext32.h>
-#endif
+#include <asm/i387.h>
 #include <asm/xcr.h>
 
 /*
-- 
1.6.0.6



