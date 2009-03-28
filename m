Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbZC1PRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbZC1PRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 11:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZC1PRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 11:17:07 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36306 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbZC1PRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 11:17:05 -0400
Date: Sat, 28 Mar 2009 15:17:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
In-Reply-To: <1238251730.2526.2.camel@ht.satnam>
Message-ID: <Pine.LNX.4.64.0903281508410.21235@blonde.anvils>
References: <1238251730.2526.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009, Jaswinder Singh Rajput wrote:
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

Gasp.

Please find a better use for your time.

Imagine, there might be developers out there with real work
to do in these files: all you are doing is throwing silly
little obstacles in their way.

IMHO
Hugh

[snip most of it to leave one example]

> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -1,17 +1,18 @@
> +#include <linux/kprobes.h>
> +#include <linux/vmalloc.h>
>  #include <linux/module.h>
> -#include <linux/sched.h>
>  #include <linux/mutex.h>
> +#include <linux/sched.h>
>  #include <linux/list.h>
> -#include <linux/kprobes.h>
>  #include <linux/mm.h>
> -#include <linux/vmalloc.h>
> +
>  #include <asm/alternative.h>
> +#include <asm/cacheflush.h>
>  #include <asm/sections.h>
> +#include <asm/vsyscall.h>
>  #include <asm/pgtable.h>
>  #include <asm/mce.h>
>  #include <asm/nmi.h>
> -#include <asm/vsyscall.h>
> -#include <asm/cacheflush.h>
>  #include <asm/io.h>
>  
>  #define MAX_PATCH_LEN (255-1)
