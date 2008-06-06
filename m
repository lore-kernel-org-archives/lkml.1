Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbYFFVH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbYFFVH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbYFFVHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:07:14 -0400
Received: from www.tglx.de ([62.245.132.106]:47246 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758664AbYFFVHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:07:13 -0400
Date: Fri, 6 Jun 2008 23:06:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Top kernel oopses/warnings for the week of Friday June 6th,
 2008
In-Reply-To: <20080606135532.0dd2b2f6@linux.intel.com>
Message-ID: <alpine.LFD.1.10.0806062303400.3235@apollo.tec.linutronix.de>
References: <484988C8.1080105@linux.intel.com> <alpine.LFD.1.10.0806062234420.3235@apollo.tec.linutronix.de> <20080606135532.0dd2b2f6@linux.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Arjan van de Ven wrote:
> On Fri, 6 Jun 2008 22:37:50 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 6 Jun 2008, Arjan van de Ven wrote:
> > > 
> > > Rank 8: tick_broadcast_oneshot_control (deadlock)
> > > 	Reported 95 times (315 total reports)
> > > 	The deadlock/timeout detector triggers in this codepath
> > > rather agressively. I'm hesitant
> > > 	to pin this one on bad hardware, it's happening too
> > > repeastedly too much.
> > > 	This deadlock was last seen in version 2.6.25.3, and first
> > > seen in 2.6.24-rc4.
> > > 	More info:
> > > http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control
> > 
> > Is there a way to tell on which kind of systems this shows
> > up ?
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=444059
> https://bugzilla.redhat.com/show_bug.cgi?id=442920
> 
> either one of those persons might be willing to help;)

Sigh, the magically resolved bug which takes ages to reproduce and
therefor makes bisection across thousands of commits a nightmare.

I was more looking for an "easy" reproducer :)

Thanks,

	tglx
