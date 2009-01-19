Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZASLTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZASLTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZASLTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:19:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZASLTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:19:43 -0500
Date: Mon, 19 Jan 2009 12:19:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
Message-ID: <20090119111932.GC18996@elte.hu>
References: <1232296759-2253-1-git-send-email-tj@kernel.org> <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com> <4973E938.4010408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4973E938.4010408@kernel.org>
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

> Hello, Ingo, Brian.
> 
> Brian Gerst wrote:
> > 
> > Here are the remaining patches rebased on top of these.
> 
> Ingo, here's git tree for kill-pda patches.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> I dropped early irq_stack_ptr relocation from 0004.  I'll post updated 
> patch as reply to the original patch.  If you think it's still 
> necessary, please feel free to discuss it.  I also added a patch to kill 
> PERCPU_VADDR_PREALLOC().  Will post the patch as a reply to 0005.

Pulled these commit into tip/core/percpu:

 9624f47: linker script: kill PERCPU_VADDR_PREALLOC()
 625a266: x86-64: Remove pda.h
 a5f0e6c: x86-64: Move stack_canary into irq_stack
 0840513: x86-64: Rework __per_cpu_load adjustments
 53372e8: percpu: Refactor percpu.h
 f6ced7a: x86-64: Remove pda_init()

thanks guys!

	Ingo
