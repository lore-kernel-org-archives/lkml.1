Return-Path: <linux-kernel-owner+w=401wt.eu-S965539AbXDVINC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbXDVINC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965549AbXDVINB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:13:01 -0400
Received: from holomorphy.com ([66.93.40.71]:57749 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965539AbXDVINA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:13:00 -0400
Date: Sun, 22 Apr 2007 01:07:08 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070422080708.GI2986@holomorphy.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704211417.03598.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704211417.03598.gene.heskett@gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 02:17:02PM -0400, Gene Heskett wrote:
> CFS-v4 is quite smooth in terms of the users experience but after prolonged 
> observations approaching 24 hours, it appears to choke the cpu hog off a bit 
> even when the system has nothing else to do.  My amanda runs went from 1 to 
> 1.5 hours depending on how much time it took gzip to handle the amount of 
> data tar handed it, up to about 165m & change, or nearly 3 hours pretty 
> consistently over 5 runs.

Welcome to infinite history. I'm not surprised, apart from the time
scale of anomalies being much larger than I anticipated.


On Sat, Apr 21, 2007 at 02:17:02PM -0400, Gene Heskett wrote:
> sd-0.44 so far seems to be handling the same load (theres a backup running 
> right now) fairly well also, and possibly theres a bit more snap to the 
> system now.  A switch to screen 1 from this screen 8, and the loading of that 
> screen image, which is the Cassini shot of saturn from the backside, the one 
> showing that teeny dot to the left of Saturn that is actually us, took 10 
> seconds with the stock 2.6.21-rc7, 3 seconds with the best of Ingo's patches, 
> and now with Con's latest, is 1 second flat. Another screen however is 4 
> seconds, so maybe that first scren had been looked at since I rebooted. 
> However, amanda is still getting estimates so gzip hasn't put a tiewrap 
> around the kernels neck just yet.

Not sure what you mean by gzip putting a tiewrap around the kernel's neck.
Could you clarify?


On Sat, Apr 21, 2007 at 02:17:02PM -0400, Gene Heskett wrote:
> Some minutes later, gzip is smunching /usr/src, and the machine doesn't even 
> know its running as sd-0.44 isn't giving gzip more than 75% to gzip, and 
> probably averaging less than 50%. And it scared me a bit as it started out at 
> not over 5% for the first minute or so.  Running in the 70's now according to 
> gkrellm, with an occasional blip to 95%.  And the machine generally feels 
> good.

I wonder what's behind that sort of initial and steady-state behavior.


On Sat, Apr 21, 2007 at 02:17:02PM -0400, Gene Heskett wrote:
> I had previously given CFS-v4 a 95 score but that was before I saw
> the general slowdown, and I believe my first impression of this one
> is also a 95.  This on a scale of the best one of the earlier CFS
> patches being 100, and stock 2.6.21-rc7 gets a 0.0.  This scheduler
> seems to be giving gzip ever more cpu as time progresses, and the cpu
> is warming up quite nicely, from about 132F idling to 149.9F now.
> And my keyboard is still alive and well.
> Generally speaking, Con, I believe this one is also a keeper.  And we'll see 
> how long a backup run takes.

Pardon my saying so but you appear to be describing anomalous behavior
in terms of "scheduler warmups."
