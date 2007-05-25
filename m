Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbXEYLU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbXEYLU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXEYLUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:20:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34122 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbXEYLUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:20:22 -0400
Date: Fri, 25 May 2007 13:20:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525112020.GN8094@one.firstfloor.org>
References: <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525101248.GA7547@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 12:12:48PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > please indicate that you've picked up my style cleanups, i dont want 
> > > to redo all this a few days/weeks down the line ...
> > 
> > It's done slightly differently now due to conflicting earlier changes, 
> > but the end result should be about what you intended. [...]
> 
> please send me your current sched-clock.c, i'll redo any remaining 
> cleanups.

It needs at least one new preliminary patch (to add on_cpu_single);
please get the series from 
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches-2.6.22-rc2-git7-070525-1.tar.gz
You need at least tsc-unstable upto paravirt-add-a-sched_clock-paravirt
for everything

> But ... i find your approach curious, why didnt you just apply the 
> cleanups i sent? You clearly started working on this as a reaction to my 
> cleanup patches and to the bugfixes i sent ontop of the cleanup patches. 
> Your "I'll do this differently" approach is totally unnecessary from a 
> commit management point of view (this is new code after all and 
> will/should go upstream in a single clean chunk anyway), the only effect 
> this has is that that you are discouraging contributors like me from 
> contributing cleanups to the x86_64 tree.

Unfortunately right now it is a already a set of patches; e.g. due to 
the paravirt ops change. I can merge back the cleanup change; but
kept it separately due to your earlier complaint about not using
your patch. I think one hunk of your original one is still in there :-)

> so to me the impression is 
> that deep in yourself you are (subconsciously) not happy about others 
> contributing to the x86_64 tree. Please tell me that i'm wrong :-(

You're reading too much into that. Of course I value contributions
to x86-64, including cleanups. In general when I don't like it I complain
so saying nothing is approval (or me being not reading email, but that
doesn't happen that often) 

-Andi
