Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYC1LQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYC1LQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYC1LQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:16:30 -0400
Received: from www.tglx.de ([62.245.132.106]:35222 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYC1LQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:16:29 -0400
Date: Fri, 28 Mar 2008 12:16:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <20080328111334.GD32200@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.00.0803281215120.3781@apollo.tec.linutronix.de>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803281004440.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803281155350.3781@apollo.tec.linutronix.de> <1206702025.8514.624.camel@twins> <20080328111334.GD32200@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Adrian Bunk wrote:
> On Fri, Mar 28, 2008 at 12:00:25PM +0100, Peter Zijlstra wrote:
> > On Fri, 2008-03-28 at 11:58 +0100, Thomas Gleixner wrote:
> > > On Fri, 28 Mar 2008, Thomas Gleixner wrote:
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9969
> > > > > Subject		: 2.6.24-git15 Keyboard Issue?
> > > > > Submitter	: Chris Holvenstot <cholvenstot@comcast.net>
> > > > > Date		: 2008-02-06 14:02 (51 days old)
> > > > > References	: http://lkml.org/lkml/2008/2/6/100
> > > > > 		  http://lkml.org/lkml/2008/2/13/82
> > > > > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> > > > > Patch		: http://lkml.org/lkml/2008/2/15/343
> > > >  
> > > > asked the bug reporter for an update.
> > > 
> > > Now that lkml.org is working again, I checked the patch which is
> > > referenced above and I have a hard time to connect it even remotely to
> > > that bug.
> > > 
> > > As far as I can tell the discussion on lkml identified GROUP_SCHED=y
> > > as the culprit, but I have no idea whether there was any resolution
> > > other than disabling GROUP_SCHED.
> > > 
> > > Peter ??
> > 
> > Correct, I am working on the issue but that's not going to be .25 stuff.
> 
> How are we going to get 2.6.25 working no worse than 2.6.24?
> 
> Letting GROUP_SCHED depend on BROKEN would sound logical, but that would 
> also kill FAIR_GROUP_SCHED.

I think default it to off should be sufficient.

Thanks,
	tglx
