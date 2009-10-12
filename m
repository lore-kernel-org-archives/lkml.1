Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbZJLQFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbZJLQFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZJLQFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:05:41 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:50616 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932729AbZJLQFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:05:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAFTw0kpMROOX/2dsb2JhbACBUtV5hC0E
Date: Mon, 12 Oct 2009 12:05:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091012160503.GA31249@Krystal>
References: <20091008191754.GA12729@Krystal> <alpine.DEB.1.10.0910081520210.8030@gentwo.org> <20091008203724.GA15798@Krystal> <alpine.DEB.1.10.0910081652190.8030@gentwo.org> <20091012135600.GB15605@Krystal> <alpine.DEB.1.10.0910121049580.32595@gentwo.org> <20091012152627.GA27835@Krystal> <alpine.DEB.1.10.0910121122400.21558@gentwo.org> <20091012153844.GA29116@Krystal> <alpine.DEB.1.10.0910121137100.21558@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910121137100.21558@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:04:37 up 55 days,  2:54,  3 users,  load average: 0.52, 0.34,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Mon, 12 Oct 2009, Mathieu Desnoyers wrote:
> 
> > local_irq_enable();
> > preempt_enable(); <- barrier()
> >
> > In the first scenario, the compiler barrier is at the beginning of the
> > slow path function, which should impose less restrictions on the compiler
> > optimizations.
> 
> Again: The next statement is a call to a function that calls the page
> allocator. Its one call vs two for me. Plus the flow of things is much
> cleaner and less obfuscated.
> 

That's a convincing argument, I agree.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
