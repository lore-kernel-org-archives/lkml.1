Return-Path: <linux-kernel-owner+w=401wt.eu-S1422891AbXDXRqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422891AbXDXRqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422889AbXDXRqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:46:07 -0400
Received: from 1wt.eu ([62.212.114.60]:2251 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422881AbXDXRqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:46:05 -0400
Date: Tue, 24 Apr 2007 19:44:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Lang <david.lang@digitalinsight.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070424174445.GA31270@1wt.eu>
References: <200704220959.34978.kernel@kolivas.org> <Pine.LNX.4.63.0704232342440.7121@qynat.qvtvafvgr.pbz> <20070424072408.GA27769@elte.hu> <200704241038.32766.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704241038.32766.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 10:38:32AM -0400, Gene Heskett wrote:
> On Tuesday 24 April 2007, Ingo Molnar wrote:
> >* David Lang <david.lang@digitalinsight.com> wrote:
> >> > (Btw., to protect against such mishaps in the future i have changed
> >> > the SysRq-N [SysRq-Nice] implementation in my tree to not only
> >> > change real-time tasks to SCHED_OTHER, but to also renice negative
> >> > nice levels back to 0 - this will show up in -v6. That way you'd
> >> > only have had to hit SysRq-N to get the system out of the wedge.)
> >>
> >> if you are trying to unwedge a system it may be a good idea to renice
> >> all tasks to 0, it could be that a task at +19 is holding a lock that
> >> something else is waiting for.
> >
> >Yeah, that's possible too, but +19 tasks are getting a small but
> >guaranteed share of the CPU so eventually it ought to release it. It's
> >still a possibility, but i think i'll wait for a specific incident to
> >happen first, and then react to that incident :-)
> >
> >	Ingo
> 
> In the instance I created, even the SysRq+b was ignored, and ISTR thats 
> supposed to initiate a reboot is it not?  So it was well and truly wedged.

On many machines I use this on, I have to release Alt while still holding B.
Don't know why, but it works like this.

Willy

