Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXDTD5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXDTD5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 23:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXDTD5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 23:57:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:44414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbXDTD5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 23:57:44 -0400
Date: Fri, 20 Apr 2007 05:57:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
Message-ID: <20070420035717.GA1028@wotan.suse.de>
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <46276BE5.7020001@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46276BE5.7020001@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:17:25AM -0400, Mark Lord wrote:
> Con Kolivas wrote:
> s go ahead and think up great ideas for other ways of metering out cpu 
> >bandwidth for different purposes, but for X, given the absurd simplicity 
> >of renicing, why keep fighting it? Again I reiterate that most users of SD 
> >have not found the need to renice X anyway except if they stick to old 
> >habits of make -j4 on uniprocessor and the like, and I expect that those 
> >on CFS and Nicksched would also have similar experiences.
> 
> Just plain "make" (no -j2 or -j9999) is enough to kill interactivity
> on my 2GHz P-M single-core non-HT machine with SD.

Is this with or without X reniced?


> But with the very first posted version of CFS by Ingo,
> I can do "make -j2" no problem and still have a nicely interactive destop.

How well does cfs run if you have the granularity set to something
like 30ms (30000000)?
