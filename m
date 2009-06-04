Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZFDRWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZFDRWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZFDRWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:22:04 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:35319 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZFDRWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:22:03 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 12:18:42 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <20090604170820.GA9823@prithivi.gnumonks.org>
In-Reply-To: <20090604170820.GA9823@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041218.44683.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Harald Welte wrote:
> Dear Linus and others,
> 
> On Thu, Jun 04, 2009 at 09:13:15AM -0700, Linus Torvalds wrote:
> 
> > > There have been reports of hangs on various VIA C7 machines going back
> > > a year now. The version of the kernel doesn't seem to matter, but the
> > > version of glibc does. Unfortunately there hasn't been much progress
> > > in getting to the bottom of it.
> > > 
> > > See here (and other linked reports):
> > > http://bugs.gentoo.org/show_bug.cgi?id=228263
> > 
> > Hmm. That looks like a CPU problem, but hey, it might be that the glibc 
> > version thing is just coincidence, and just changes timings or whatever, 
> > and the problem is in the chipsets.
> > 
> > So at least from that particular report it smells very much 
> > non-kernel-related.
> > 
> > That said, even if it isn't kernel-related, it might be fixable with some 
> > kernel patch that changes the setup of the CPU/chipset. But we'd need VIA 
> > to help with anythign like that.
> 
> So far, inside VIA there is no well-known issue/bug about such hangs / locks at
> all.
> 
> I have seen a number (probably between 5 or 10) of sporadic reports from a
> number of people on a variety of systems.  Some from actual commercial vendors
> of VIA+Linux based appliances, and some from the wider community of end users.
> So far, to the best of my knowledge, none of those isseus has been narrowed
> down to a sufficiently easy to reproduce test case.  Also, none of the bug
> reporters has so far been able to reproduce the problem on a genuine VIA
> mainboard, i.e. it could be issues introduced by the actual board hardware or
> how the speicfic BIOS initializes the low-level hardware.
> 
> Especially when SMI/SMM based debugging no longer works (i.e. something that
> appears to be a bus lockup), the actual bug needs to be reproduced on a
> reference board that can be hooked up to a logic/protocol analyzer.
> 
> On the other hand, VIA's CPU division (CentaurLabs) is performing extensive
> testing on their CPUs with a large codebase of x86 code, AFAIK based on more
> than 40 operating systems.  Also, there are large quantities of VIA CPU+chipset
> systems that run without any problem, especially in 24/7 embedded x86 worloads
> on Linux...
> 
> I'm more than determined to help resolving those sporadic Linux lock-up
> problems. It feels like there is some problem out there, given the fact that
> there is a number of independent reporters who talk about some kind of hard
> system hang without oops that even prevents the NMI watchdog to kick in.
> 
> However, unless we can somehow narrow down at least one of those reports into
> something  that is easier to reproduce, and which can actuall be reproduced on
> a VIA board.  Triggering in 1-4 hours is already very good, I have reports
> where 1 of 30 system exposes a lock once within 5 days of continuous full
> application workload.
> 
> Sure, third party BIOS/board vendors selling products that randomly produce
> locks are obviously also not a particularly great advertisement for VIA...
> but debigging on such a board is much more difficult due to the lack of access
> to BIOS sources, schematics and hardware debugging interfaces.
> 
> In any case, if somebody can ship me a system that exposes one of those
> lock-ups, together with a pre-installed test case that exposes the problem
> within let's say less than one day, plus the full kernel sources used in
> that particular system:  I'm happy to spend time to investigate the issue,
> try to run the same test case on a VIA board, etc.
> 

I am about at my wits end with this Everex product -

Give me a couple more weeks at the problem and if I haven't solved it;
I'll give you this machine if you promise to update LKML with any fix.

Mike
> Any additional help is much appreciated.
> 
> Regards,


