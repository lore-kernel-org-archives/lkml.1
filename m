Return-Path: <linux-kernel-owner+w=401wt.eu-S934562AbZARQtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562AbZARQtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbZARQtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:49:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386AbZARQtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:49:13 -0500
Date: Sun, 18 Jan 2009 17:49:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, brgerst@gmail.com
Subject: Re: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
Message-ID: <20090118164903.GA27657@elte.hu>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> 
> Hello, Brian, Ingo.
> 
> This patchset is 1-12 of Brian's move PDA fields to percpu patchset.
> 
>  0001-x86-64-Move-irq-stats-from-PDA-to-per-cpu-and-conso.patch
>  0002-x86-64-Move-TLB-state-from-PDA-to-per-cpu-and-conso.patch
>  0003-x86-64-Convert-irqstacks-to-per-cpu.patch
>  0004-x86-64-Convert-exception-stacks-to-per-cpu.patch
>  0005-x86-64-Move-cpu-number-from-PDA-to-per-cpu-and-cons.patch
>  0006-x86-64-Move-current-task-from-PDA-to-per-cpu-and-co.patch
>  0007-x86-64-Move-kernelstack-from-PDA-to-per-cpu.patch
>  0008-x86-64-Move-oldrsp-from-PDA-to-per-cpu.patch
>  0009-x86-64-Move-irqcount-from-PDA-to-per-cpu.patch
>  0010-x86-64-Move-nodenumber-from-PDA-to-per-cpu.patch
>  0011-x86-64-Move-isidle-from-PDA-to-per-cpu.patch
>  0012-x86-64-Use-absolute-displacements-for-per-cpu-acces.patch
> 
> with the following changes
> 
> * Add underbars between words in variable names (e.g. irqstack ->
>   irq_stack)
> 
> * Drop irq_stack_ptr early initialization on SMP from 0003.
> 
> * Change DECLARE/DEFINE_PER_CPU(char, irq_stack[IRQ_STACK_SIZE]) to
>   DECLARE/DEFINE_PER_CPU(char[IRQ_STACK_SIZE], irq_stack) in 0003.
>          
> * Move cpu_number definition out of CONFIG_HAVE_SETUP_PER_CPU_AREA
>   in 0005.
> 
> * Remove now unused stack_thread_info() in 0007.
> 
> Please pull from
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Pulled, thanks Tejun!

	Ingo
