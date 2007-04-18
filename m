Return-Path: <linux-kernel-owner+w=401wt.eu-S1422931AbXDRMOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422931AbXDRMOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422953AbXDRMOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:14:23 -0400
Received: from ns.suse.de ([195.135.220.2]:44830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422931AbXDRMOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:14:22 -0400
Date: Wed, 18 Apr 2007 14:14:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418121421.GB878@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <20070417095900.GB25553@elte.hu> <20070418085525.GA21194@wotan.suse.de> <200704181933.57057.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704181933.57057.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 07:33:56PM +1000, Con Kolivas wrote:
> On Wednesday 18 April 2007 18:55, Nick Piggin wrote:
> > Again, for comparison 2.6.21-rc7 mainline:
> >
> > 508.87user 32.47system 2:17.82elapsed 392%CPU
> > 509.05user 32.25system 2:17.84elapsed 392%CPU
> > 508.75user 32.26system 2:17.83elapsed 392%CPU
> > 508.63user 32.17system 2:17.88elapsed 392%CPU
> > 509.01user 32.26system 2:17.90elapsed 392%CPU
> > 509.08user 32.20system 2:17.95elapsed 392%CPU
> >
> > So looking at elapsed time, a granularity of 100ms is just behind the
> > mainline score. However it is using slightly less user time and
> > slightly more idle time, which indicates that balancing might have got
> > a bit less aggressive.
> >
> > But anyway, it conclusively shows the efficiency impact of such tiny
> > timeslices.
> 
> See test.kernel.org for how (the now defunct) SD was performing on kernbench. 
> It had low latency _and_ equivalent throughput to mainline. Set the standard 
> appropriately on both counts please.

I can give it a run. Got an updated patch against -rc7?

