Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZJHTXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZJHTXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZJHTXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:23:34 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:49906 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbZJHTXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:23:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwEAH/UzUpMROOX/2dsb2JhbACBUtkOhCoE
Date: Thu, 8 Oct 2009 15:17:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091008191754.GA12729@Krystal>
References: <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <1254988350.26976.256.camel@twins> <alpine.DEB.1.10.0910081211050.21951@gentwo.org> <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910081342540.7735@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:17:41 up 51 days,  6:07,  2 users,  load average: 0.12, 0.26,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Thu, 8 Oct 2009, Mathieu Desnoyers wrote:
> 
> > Then how do you re-enable preemption in the slow path when you need to
> > block ?
> 
> preempt_enable();
> 
> before the page allocator call and
> 
> preempt_disable();
> 
> afterwards.
> 

OK, sounds good,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
