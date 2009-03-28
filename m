Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbZC1PAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbZC1PAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 11:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZC1PAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 11:00:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:9682 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZC1PAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 11:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p9B+pgNJG5MuP//o6ujrlDQe4c5daF8zoIaP983EZICAE6UHrhNjkNwtBCYAqa2Rvb
         o714C5gJpBvU9ozDbNbGqLsF4xdK8fwMqG2gUTiBstTQ5BZXiCZ+xwaR4F4i4F38nkf1
         uzm5sst3W5gisutV9on2Lwfp5vmqhfZEBubro=
Date: Sat, 28 Mar 2009 18:07:46 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090328150746.GA3268@x200.localdomain>
References: <1238251730.2526.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238251730.2526.2.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 08:18:50PM +0530, Jaswinder Singh Rajput wrote:
> The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
>   Ingo Molnar (1):
>         Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> 
> Jaswinder Singh Rajput (49):
>       x86: process_32.c include inverse Xmas tree effect

What the heck is this?

>       x86: signal.c include inverse Xmas tree effect
>       x86: entry_32.S include inverse Xmas tree effect
>       x86: traps.c include inverse Xmas tree effect
>       x86: irq.c include inverse Xmas tree effect
>       x86: irq_32.c include inverse Xmas tree effect
>       x86: dumpstack.c include inverse Xmas tree effect
>       x86: time_32.c include inverse Xmas tree effect
>       x86: ioport.c include inverse Xmas tree effect
>       x86: ldt.c include inverse Xmas tree effect
>       x86: dumpstack_32.c include inverse Xmas tree effect
>       x86: setup.c include inverse Xmas tree effect
>       x86: i8259.c include inverse Xmas tree effect
>       x86: irqinit_32.c include inverse Xmas tree effect
>       x86: probe_roms_32.c include inverse Xmas tree effect
>       x86: sys_i386_32.c include inverse Xmas tree effect
>       x86: i386_ksyms_32.c include inverse Xmas tree effect
>       x86: bootflag.c include inverse Xmas tree effect
>       x86: e820.c include inverse Xmas tree effect
>       x86: pci-dma.c include inverse Xmas tree effect
>       x86: quirks.c include inverse Xmas tree effect
>       x86: i8237.c include inverse Xmas tree effect
>       x86: alternative.c include inverse Xmas tree effect
>       x86: tsc.c include inverse Xmas tree effect
>       x86: process.c include inverse Xmas tree effect
>       x86: xsave.c include inverse Xmas tree effect
>       x86: ptrace.c include inverse Xmas tree effect
>       x86: ds.c include inverse Xmas tree effect
>       x86: tls.c include inverse Xmas tree effect
>       x86: step.c include inverse Xmas tree effect
>       x86: stacktrace.c include inverse Xmas tree effect
>       x86: reboot.c include inverse Xmas tree effect
>       x86: msr.c include inverse Xmas tree effect
>       x86: cpuid.c include inverse Xmas tree effect
>       x86: early-quirks.c include inverse Xmas tree effect
>       x86: smp.c include inverse Xmas tree effect
>       x86: smpboot.c include inverse Xmas tree effect
>       x86: tsc_sync.c include inverse Xmas tree effect
>       x86: setup_percpu.c include inverse Xmas tree effect
>       x86: trampoline_32.S include inverse Xmas tree effect
>       x86: mpparse.c include inverse Xmas tree effect
>       x86: module_32.c include inverse Xmas tree effect
>       x86: doublefault_32.c include inverse Xmas tree effect
>       x86: vm86_32.c include inverse Xmas tree effect
>       ix86: early_printk.c include inverse Xmas tree effect
>       x86: pcspeaker.c include inverse Xmas tree effect
>       x86: head_32.c include inverse Xmas tree effect
>       x86: head.c include inverse Xmas tree effect
>       x86: init_task.c include inverse Xmas tree effect
> 
>  arch/x86/include/asm/proto.h         |    2 +
>  arch/x86/include/asm/sigcontext32.h  |    3 +-
>  arch/x86/include/asm/smpboot_hooks.h |    2 +
>  arch/x86/include/asm/topology.h      |    2 +
>  arch/x86/kernel/alternative.c        |   11 ++--
>  arch/x86/kernel/bootflag.c           |   12 ++--
>  arch/x86/kernel/cpuid.c              |   17 ++---
>  arch/x86/kernel/doublefault_32.c     |    8 +-
>  arch/x86/kernel/ds.c                 |   11 +--
>  arch/x86/kernel/dumpstack.c          |    5 +-
>  arch/x86/kernel/dumpstack_32.c       |    5 +-
>  arch/x86/kernel/e820.c               |   21 +++---
>  arch/x86/kernel/early-quirks.c       |    9 ++-
>  arch/x86/kernel/early_printk.c       |   26 ++++---
>  arch/x86/kernel/entry_32.S           |   17 +++--
>  arch/x86/kernel/head.c               |    2 +-
>  arch/x86/kernel/head_32.S            |   17 +++--
>  arch/x86/kernel/i386_ksyms_32.c      |    3 +-
>  arch/x86/kernel/i8237.c              |    3 +-
>  arch/x86/kernel/i8259.c              |   28 ++++----
>  arch/x86/kernel/init_task.c          |    8 +-
>  arch/x86/kernel/ioport.c             |   15 ++--
>  arch/x86/kernel/irq.c                |   11 ++--
>  arch/x86/kernel/irq_32.c             |   10 ++--
>  arch/x86/kernel/irqinit_32.c         |   29 ++++----
>  arch/x86/kernel/ldt.c                |   14 ++--
>  arch/x86/kernel/module_32.c          |    7 +-
>  arch/x86/kernel/mpparse.c            |   24 +++---
>  arch/x86/kernel/msr.c                |   17 ++---
>  arch/x86/kernel/pci-dma.c            |   10 ++--
>  arch/x86/kernel/pcspeaker.c          |    2 +-
>  arch/x86/kernel/probe_roms_32.c      |   23 +++---
>  arch/x86/kernel/process.c            |   19 +++---
>  arch/x86/kernel/process_32.c         |   70 +++++++++----------
>  arch/x86/kernel/ptrace.c             |   30 ++++----
>  arch/x86/kernel/quirks.c             |    4 +-
>  arch/x86/kernel/reboot.c             |   30 ++++----
>  arch/x86/kernel/setup.c              |  126 ++++++++++++++++------------------
>  arch/x86/kernel/setup_percpu.c       |   21 +++---
>  arch/x86/kernel/signal.c             |   33 ++++-----
>  arch/x86/kernel/smp.c                |   16 ++--
>  arch/x86/kernel/smpboot.c            |   33 ++++-----
>  arch/x86/kernel/stacktrace.c         |    6 +-
>  arch/x86/kernel/step.c               |    3 +-
>  arch/x86/kernel/sys_i386_32.c        |   25 +++----
>  arch/x86/kernel/time_32.c            |    7 +-
>  arch/x86/kernel/tls.c                |   10 ++--
>  arch/x86/kernel/trampoline_32.S      |    3 +-
>  arch/x86/kernel/traps.c              |   34 +++------
>  arch/x86/kernel/tsc.c                |   20 +++---
>  arch/x86/kernel/tsc_sync.c           |    2 +-
>  arch/x86/kernel/vm86_32.c            |   20 +++---
>  arch/x86/kernel/xsave.c              |    5 +-
>  53 files changed, 437 insertions(+), 454 deletions(-)
> 
> Complete diff:
> diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
> index 49fb3ec..a8d63be 100644
> --- a/arch/x86/include/asm/proto.h
> +++ b/arch/x86/include/asm/proto.h
> @@ -7,7 +7,9 @@
>  
>  extern void early_idt_handler(void);
>  
> +#ifdef CONFIG_X86_64
>  extern void system_call(void);
> +#endif
>  extern void syscall_init(void);
>  
>  extern void ia32_syscall(void);
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
> diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
> index 1def601..dff6e11 100644
> --- a/arch/x86/include/asm/smpboot_hooks.h
> +++ b/arch/x86/include/asm/smpboot_hooks.h
> @@ -1,6 +1,8 @@
>  /* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
>   * which needs to alter them. */
>  
> +#include <asm/tlbflush.h>
> +
>  static inline void smpboot_clear_io_apic_irqs(void)
>  {
>  #ifdef CONFIG_X86_IO_APIC
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index 77cfb2c..1f23e58 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -194,10 +194,12 @@ extern int __node_distance(int, int);
>  
>  #else /* !CONFIG_NUMA */
>  
> +#if 0
>  static inline int numa_node_id(void)
>  {
>  	return 0;
>  }
> +#endif
>  
>  static inline int cpu_to_node(int cpu)
>  {
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 4c80f15..51fb5c5 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -1,17 +1,18 @@
> +#include <linux/kprobes.h>
> +#include <linux/vmalloc.h>
>  #include <linux/module.h>
> -#include <linux/sched.h>
