Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZAGMwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZAGMwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZAGMwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:52:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56832 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbZAGMwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:52:19 -0500
Date: Wed, 7 Jan 2009 13:51:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
Message-ID: <20090107125152.GA3529@elte.hu>
References: <1231329368.17961.29.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231329368.17961.29.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> These are first set of patches for removing NON-SMP data from smp.h as suggested by Ingo.
> 
> The following changes since commit b97d41dd7df418cacfa01e399d35927bbdff600f:
>   Ingo Molnar (1):
>         Merge branch 'out-of-tree'
> 
> Jaswinder Singh Rajput (7):
>       x86: smp.h remove obsolete function declaration
>       x86: smp.h move zap_low_mappings declartion to tlbflush.h
>       x86: smp.h move prefill_possible_map declartion to cpu.h
>       x86: smp.h move stack_processor_id declartion to cpu.h
>       x86: smp.h move safe_smp_processor_id declartion to cpu.h
>       x86: smp.h move cpu_physical_id declartion to cpu.h
>       x86: smp.h move boot_cpu_id declartion to cpu.h
> 
>  arch/x86/include/asm/cpu.h      |   21 +++++++++++++++++++++
>  arch/x86/include/asm/smp.h      |   19 -------------------
>  arch/x86/include/asm/tlbflush.h |    2 ++
>  arch/x86/kernel/cpu/common.c    |    2 +-
>  arch/x86/kernel/io_apic.c       |    1 +
>  arch/x86/kernel/setup.c         |    2 +-
>  arch/x86/kernel/smpboot.c       |    1 -
>  arch/x86/mach-voyager/setup.c   |    1 +
>  arch/x86/mm/init_32.c           |    1 -
>  drivers/pci/intr_remapping.c    |    1 +
>  10 files changed, 28 insertions(+), 23 deletions(-)

applied to tip/x86/cleanups:

 a1d2aa6: x86: smp.h move boot_cpu_id declartion to cpu.h
 17b986a: x86: smp.h move cpu_physical_id declartion to cpu.h
 e3b687f: x86: smp.h move safe_smp_processor_id declartion to cpu.h
 d32195e: x86: smp.h move stack_processor_id declartion to cpu.h
 6e5385d: x86: smp.h move prefill_possible_map declartion to cpu.h
 dacf733: x86: smp.h move zap_low_mappings declartion to tlbflush.h
 7760ec7: x86: smp.h remove obsolete function declaration

thanks!

	Ingo
