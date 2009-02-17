Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbZBQLZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbZBQLZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZBQLY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:24:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZBQLY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:24:57 -0500
Date: Tue, 17 Feb 2009 12:24:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fold apic_ops into genapic -v2
Message-ID: <20090217112442.GB18557@elte.hu>
References: <499A1316.9000204@kernel.org> <499A136D.2040006@kernel.org> <499A60F6.5080704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499A60F6.5080704@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: cleanup
> 
> make it simple, don't need have one extra struct
> v2: fix sgi_uv compiling
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/apic.h               |   97 +++++++++---------------------
>  arch/x86/include/asm/genapic.h            |   61 ++++++++++++++++++
>  arch/x86/kernel/apic.c                    |   63 +------------------
>  arch/x86/kernel/bigsmp_32.c               |    7 ++
>  arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 
>  arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 
>  arch/x86/kernel/cpu/perf_counter.c        |    2 
>  arch/x86/kernel/cpu/perfctr-watchdog.c    |    2 
>  arch/x86/kernel/es7000_32.c               |    7 ++
>  arch/x86/kernel/genapic_64.c              |    2 
>  arch/x86/kernel/genapic_flat_64.c         |   16 ++++
>  arch/x86/kernel/genx2apic_cluster.c       |   11 ++-
>  arch/x86/kernel/genx2apic_phys.c          |   11 ++-
>  arch/x86/kernel/genx2apic_uv_x.c          |    9 ++
>  arch/x86/kernel/ipi.c                     |    2 
>  arch/x86/kernel/irq.c                     |    2 
>  arch/x86/kernel/nmi.c                     |    2 
>  arch/x86/kernel/numaq_32.c                |    7 ++
>  arch/x86/kernel/probe_32.c                |    7 ++
>  arch/x86/kernel/summit_32.c               |    7 ++
>  arch/x86/kernel/uv_irq.c                  |    2 
>  arch/x86/kernel/vmi_32.c                  |    6 -
>  arch/x86/kernel/vmiclock_32.c             |    2 
>  arch/x86/lguest/boot.c                    |   19 +++--
>  arch/x86/xen/enlighten.c                  |   21 +++---
>  25 files changed, 206 insertions(+), 163 deletions(-)

Applied to tip:x86/apic, thanks Yinghai!

	Ingo
