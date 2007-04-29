Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbXD2JyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbXD2JyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbXD2JyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:54:04 -0400
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:56683 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbXD2JyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:54:00 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v6
Date: Sun, 29 Apr 2007 19:52:22 +1000
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
References: <1177618164.14496.5.camel@localhost> <20070429073819.GD23638@1wt.eu> <20070429080028.GA9988@elte.hu>
In-Reply-To: <20070429080028.GA9988@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291952.22840.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007 18:00, Ingo Molnar wrote:
> * Willy Tarreau <w@1wt.eu> wrote:
> > > > [...] except for Mike who has not tested recent versions. [...]
> > >
> > > actually, dont discount Mark Lord's test results either. And it
> > > might be a good idea for Mike to re-test SD 0.46?
> >
> > In any case, it might be a good idea because Mike encountered a
> > problem that nobody could reproduce. [...]
>
> actually, Mark Lord too reproduced something similar to Mike's results.
> Please try those workloads yourself.

I see no suggestion that either Mark or Mike have tested, or for that matter 
_have any intention of testing_, the current version of SD without fancy 
renicing or anything involved. Willy I grealy appreciate you trying, but I 
don't know why you're bothering even trying here since clearly 1. Ingo is the 
scheduler maintainer 2. he's working on a competing implementation and 3. in 
my excellent physical and mental state I seem to have slighted the two 
testers (both?) somewhere along the line. Mike feels his testing was a 
complete waste of time yet it would be ludicrous for me to say that SD didn't 
evolve 20 versions further due to his earlier testing, and was the impetus 
for you to start work on CFS. The crunch came that we couldn't agree that 
fair was appropriate for mainline and we parted ways. That fairness has not 
been a problem for his view on CFS though but he has only tested older 
versions of SD that still had bugs.

Given facts 1 and 2 above I have all but resigned myself to the fact that SD 
has -less than zero- chance of ever being considered for mainline and it's my 
job to use it as something to compare your competing design with to make sure 
that when (and I do mean when since there seems no doubt in everyone else's 
mind) CFS becomes part of mainline that it is as good as SD. Saying people 
found CFS better than SD is, in my humble opinion, an exaggeration since 
every one I could find was a glowing standalone report of CFS rather than any 
comparison to the current very stable bug free version of SD. On the other 
hand I still see that when people compare them side to side they find SD is 
better, so I will hold CFS against that comparison - when comparing fairness 
based designs.

On a related note - implementing a framework is nice but doesn't address any 
of the current fairness/starvation/corner case problems mainline has. I don't 
see much point in rushing the framework merging since it's still in flux.

-- 
-ck
