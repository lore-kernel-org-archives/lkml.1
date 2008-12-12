Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYLLGWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYLLGWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 01:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYLLGW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 01:22:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35529 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYLLGW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 01:22:29 -0500
Date: Fri, 12 Dec 2008 07:22:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eranian@googlemail.com,
       dada1@cosmosbay.com, robert.richter@amd.com, arjan@infradead.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, paulus@samba.org,
       davem@davemloft.net
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081212062200.GD12451@elte.hu>
References: <20081211155230.GA4230@elte.hu> <20081211103504.73ecabdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211103504.73ecabdd.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 11 Dec 2008 16:52:30 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > To: linux-kernel@vger.kernel.org
> > Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Stephane Eranian <eranian@googlemail.com>, Eric Dumazet <dada1@cosmosbay.com>, Robert Richter <robert.richter@amd.com>, Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>
> 
> Please copy perfctr-devel@lists.sourceforge.net on all this.  That is 
> where the real-world people who use these facilities on a regular basis 
> hang out.

Sure, we'll do that for v4.

The reason we kept posting this to lkml initially was because there is a 
visible detachment of this community from kernel developers. And that is 
at least in part because this stuff has never been made interesting 
enough to kernel developers. I dont remember a _single_ perfmon-generated 
profile (be that user-space or kernel-space) in my mailbox before - and 
optimizing the kernel is supposed to be one of the most important aspects 
of performance tuning.

That's why we concentrate on making this useful and interesting to kernel 
developers too via KernelTop, that's why we made the BTS/[PEBS] hardware 
tracer available via an ftrace plugin, etc.

Furthermore, kernel developers tend to be quite good at co-designing, 
influencing [and flaming ;-) ] such APIs at the early prototype stages, 
so the main early technical feedback we were looking for on the kernel 
side structure was lkml. But the wider community is not ignored either, 
of course - with v4 it might be useful already for wider circulation.

	Ingo
