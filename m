Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYBSOBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYBSOBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYBSOA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:00:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYBSOAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:00:55 -0500
Date: Tue, 19 Feb 2008 15:00:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219140033.GA9965@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219102700.GC14092@elte.hu> <20080219130253.GA29804@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219130253.GA29804@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Ingo, a comment in slub.c explains it :
> 
> /*
>  * The SLUB_FASTPATH path is provisional and is currently disabled if the
>  * kernel is compiled with preemption or if the arch does not support
>  * fast cmpxchg operations. There are a couple of coming changes that will
>  * simplify matters and allow preemption. Ultimately we may end up making
>  * SLUB_FASTPATH the default.

well the feature is not complete and there are no reasons given _why_ 
it's not complete ... and even if there's a reason it should have been 
deferred to the next merge window. We still have 10 year old "this is a 
temporary hack" comments in the kernel ;-)

"hardware does not support it" is a valid argument, "kernel developer 
had no time to implement it properly" is not ;-)

	Ingo
