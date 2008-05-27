Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbYE0Rnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbYE0Rnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYE0Rni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:43:38 -0400
Received: from www.tglx.de ([62.245.132.106]:41084 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYE0Rnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:43:37 -0400
Date: Tue, 27 May 2008 19:30:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@in.ibm.com>
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
In-Reply-To: <20080527130828.GC20938@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805271527060.3295@apollo.tec.linutronix.de>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi> <1211888849.12349.28.camel@twins> <20080527130828.GC20938@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008, Adrian Bunk wrote:
> On Tue, May 27, 2008 at 01:47:29PM +0200, Peter Zijlstra wrote:
> >...
> > FYI your attitude in the past few weeks is getting on my nerves - you
> > act all self important but have not made a single contribution to the
> > kernel above the level of a janitor-newbie.
> 
> Not a single contribution to the kernel above the level of a 
> janitor-newbie?
> 
> http://article.gmane.org/gmane.linux.kernel/676733
> http://lkml.org/lkml/2008/5/14/498
> http://lkml.org/lkml/2008/4/28/561
> ...

Adrian, do you really believe that the above is substantial ? 

You spotted a bug, decoded a bug report and fixed a Kconfig. Nobody
says that this is a bad contribution, but it does not qualify you at
all to act as the uber controller of the kernel.

I always defended your contributions, which were questioned by a lot
of kernel developers, but your recent attitude of artificially
inflating bugs, which are either already resolved, have patches
pending or are actively worked on is annoying a lot of kernel folks,
not only Peter.

I'm sure Peter would have accepted such a patch, if there was a good
technical reason for it.

Your book-keeper list of bugreports lacks technical insight and is not
a good technical reason, it's just a strawman to gain control and/or
importance.

The bugzilla lists are good to remind us about outstanding problems,
but they are in no way the sole technical measure for marking a
functionality broken. Bugzilla is a tracking tool, nothing else. Using
it as a technical measure is just like the management illusion that
you can control a company with spread-sheets.

Following your book-keeper logic we have to mark HIBERNATE, SUSPEND,
NOHZ, HIGHRES, TSC and tons of other things BROKEN as well.

Marking it BROKEN is the last resort when we have something unfixable
which causes data corruption or crashes for which there is no active
maintainer who's willing to stand up for breakage.

Marking an incomplete default off feature, which does not result in
crashes or data corruption, BROKEN is just wrong. EXPERIMENTAL is the
correct category to get it exposed to users which helps to get
information about the side effects.

I enjoy working with Rafael on a technical level on those bugzilla
issues, but your vain attempt to influence the kernel development by
bureaucrazy will just lead to further ignorance vs. the kernel
bugzilla as the signal/noise ratio already reached an high annoyance
level since you started to abuse it for your renewed quality crusade.

Your previous attempt to control kernel development via the regression
list failed and you resigned. Now you come back and attack particular
subsystem developers/maintainers with the same method. Do you really
believe that abusing statistics for your exaggerated problem inflation
is solving any problems ?

No, it's causing more problems because you slander and frustrate
active developers who are aware of the issues and are working hard to
resolve them. The least thing they need is "motivation" in form of
such patches.

> Awaiting your apology

For what ? For telling the truth ?

Thanks,

	tglx
