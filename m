Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbZJHMpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbZJHMpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZJHMpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:45:35 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:45339 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZJHMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:45:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEABd5zUpMROOX/2dsb2JhbACBUtd2hCoE
Date: Thu, 8 Oct 2009 08:44:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091008124456.GA13307@Krystal>
References: <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <1254988350.26976.256.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1254988350.26976.256.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:42:54 up 50 days, 23:32,  3 users,  load average: 0.55, 0.36,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2009-10-07 at 11:21 -0400, Christoph Lameter wrote:
> > On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:
> > 
> > > You are already calling the scheduler when ending the _fast_ path. I
> > > don't see the problem with calling it when you end the slow path
> > > execution.
> > 
> > Well yes that gives rise to the thought of using
> > 
> > 	preempt_enable_no_sched()
> 
> NACK, delaying the reschedule is not an option

Even if only done with interrupt off, and check resched is called after
each irq enable following this critical section ? I'd like to understand
the reason behind your rejection for this specific case.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
