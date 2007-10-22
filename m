Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXJVMfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXJVMfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXJVMfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:35:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35019 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXJVMfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:35:23 -0400
Date: Mon, 22 Oct 2007 14:35:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Use show_regs() to improve __schedule_bug()
	output
Message-ID: <20071022123506.GB4990@elte.hu>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <alpine.LFD.0.999.0709020439290.20781@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0709021803060.24993@enigma.security.iitk.ac.in> <20070902122835.GA27438@elte.hu> <alpine.LFD.0.999.0709061208120.26804@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709061208120.26804@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satyam Sharma <satyam@infradead.org> wrote:

> BTW would something similar would be useful in __schedule_bug() too? I 
> sure think so -- I'm not sure if EIP holds anything useful there, but 
> CPU#, EFLAGS and the init_utsname() stuff would be definitely helpful 
> ...
> 
> [PATCH] sched: Use show_regs() to improve __schedule_bug() output
> 
> A full register dump along with stack backtrace would make the 
> "scheduling while atomic" message more helpful. Use show_regs() 
> instead of dump_stack() for this. We already know we're atomic in here 
> (that is why this function was called) so show_regs()'s atomicity 
> expectations are guaranteed.
> 
> Also, modify the output of the "BUG: scheduling while atomic:" header 
> a bit to keep task->comm and task->pid together and preempt_count() 
> after them.

thanks, applied.

	Ingo
