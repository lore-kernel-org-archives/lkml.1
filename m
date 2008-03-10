Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYCJLIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYCJLIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYCJLHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:07:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47591 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYCJLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:07:43 -0400
Date: Mon, 10 Mar 2008 10:43:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Message-ID: <20080310094326.GA9473@elf.ucw.cz>
References: <20080306102927.GA4434@elf.ucw.cz> <20080306131547.GE21359@elte.hu> <86802c440803061127s5ca545bch930310a0df6511fc@mail.gmail.com> <20080306212419.GA13798@elf.ucw.cz> <86802c440803061458p3689ea4fi40595bddab533b70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803061458p3689ea4fi40595bddab533b70@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-06 14:58:54, Yinghai Lu wrote:
> On Thu, Mar 6, 2008 at 1:24 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >  > >  > On amd 8-core system, I get crash on boot... Last messages:
> >  > >  >
> >  > >  > Quad-Core AMD Opteron...
> >  > >  > Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
> >  > >  > BUG: unable to handle kernel paging request at 00...005958
> >  > >  > IP: __alloc_pages+0x38
> >  > >  > ...
> >  > >  > Call trace:
> >  > >  > kmem_getpages
> >  > >  > cache_grow
> >  > >  > ____cache_alloc_node
> >  > >  > cpuup_callback
> >  > >  > kmem_cache_alloc_node
> >  > >  > cpuup_callback
> >  > >  > notifier_call_chain
> >  > >  > _cpu_up
> >  > >
> >  > >  could you try latest x86.git:
> >  > >
> >  > >     http://people.redhat.com/mingo/x86.git/README
> >  > >
> >  > >  does it fix it? Could be one of the numa fixes that are queued up.
> >  >
> >
> > > can we have your config and whole bootlog?
> >
> >  Config is attached.
> >
> your config works well here with all systems. wonder if you have old cpu rev.

I definitely have "strange" cpu here. But 2.6.24 works, and this new
kernel should work, too...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
