Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbXLUWwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbXLUWwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbXLUWvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:51:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756022AbXLUWvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:51:52 -0500
Date: Fri, 21 Dec 2007 14:49:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.9999.0712211442000.21557@woody.linux-foundation.org>
References: <1197049846.1645.68.camel@localhost.localdomain> <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu>
 <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Dec 2007, Christoph Lameter wrote:
> 
> It obviously can replace it and has replaced it for awhile now.

No. If there are 6% performance regressions on TPC-C, then it CAN NOT 
replace it!

> Well still SLUB is really superior to SLAB in many ways....
> 
> - SLUB is performance wise much faster than SLAB.

No.

Christoph, statements like this is *exactly* why I don't think SLUB can 
make it.

You're closing your eyes to real performace *regression* reports, and then 
you claim thast SLUB is faster, because you find your own microbenchmarks 
that show so for specific loads.

But those specific loads are apparetly never the issue.

So stop saying that SLUB is "much faster", as long as hackbench shows that 
that is simply NOT THE CASE.

It doesn't matter one whit if SLUB is lots faster, if it's faster for 
cases that never matter. So far, I don't think we've *ever* seen any 
actual benchmarks that involve any kind of real use where SLUB is 
really faster, and we have some major examples of SLUB being disastrously 
slower!

Your special-case kmalloc performance tests don't matter, when real user 
programs show the exact opposite effect.

And the fact that you dismiss those real user programs just because you 
have your own test harness is why I'm ready to throw in the towel on SLUB. 

I don't mind performance regressions, but I *do* mind performance 
regressions when the main author then says "look, a helicopter!" and 
points to some totally different thing and claims that the performance 
regression doesn't even exist!

Because those kinds of performance regressions never get fixed, because 
they are ignored.

		Linus
