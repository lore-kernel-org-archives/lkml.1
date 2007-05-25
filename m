Return-Path: <linux-kernel-owner+w=401wt.eu-S1764776AbXEYSIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764776AbXEYSIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXEYSIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:08:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761972AbXEYSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:08:04 -0400
Date: Fri, 25 May 2007 20:08:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
Message-ID: <20070525180801.GC24083@one.firstfloor.org>
References: <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu> <20070525115004.GA4574@elte.hu> <20070525115544.GP8094@one.firstfloor.org> <20070525120228.GA7186@elte.hu> <alpine.LFD.0.98.0705250946120.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705250946120.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 09:49:38AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 25 May 2007, Ingo Molnar wrote:
> > 
> > ok - then please merge that single hunk into the paravirtops patch - and 
> > leave the other 6 hunks in this patch.
> 
> Note: I'm actually much more interested in applying the scheduler changes 
> than the paravirt-ops changes. It looks like CFS is getting stable, I'd 

That's ok -- that is why I'm keeping this stuff separate.
paravirt ops sched_clock is just on top of the new sched_clock() but
sched_clock doesn't rely on it.

Also my understanding is that CFS works even without the new sched_clock,
just the new one makes it work better.

-Andi

