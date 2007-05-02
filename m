Return-Path: <linux-kernel-owner+w=401wt.eu-S1767058AbXEBVlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767058AbXEBVlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767059AbXEBVlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:41:40 -0400
Received: from www.osadl.org ([213.239.205.134]:42299 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767058AbXEBVli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:41:38 -0400
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Guilherme Schroeder <guilherme@centralinf.com.br>,
       John Stultz <johnstul@us.ibm.com>, Mikael Pettersson <mikpe@it.uu.se>,
       ak@suse.de, discuss@x86-64.org, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <b6a2187b0704250645t62a0d8u20f1f43df6feaea@mail.gmail.com>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070423214909.GD3468@stusta.de>
	 <20070425040605.6d6b4a82.akpm@linux-foundation.org>
	 <20070425114317.GA32153@elte.hu>
	 <b6a2187b0704250645t62a0d8u20f1f43df6feaea@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 23:44:01 +0200
Message-Id: <1178142241.2340.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

On Wed, 2007-04-25 at 21:45 +0800, Jeff Chua wrote:
> On 4/25/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > > Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
> > > > References : http://lkml.org/lkml/2007/3/25/217
> > > > Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> > > > Status     : unknown
> > >
> > > That's still rather a lot of bustage from the timekeeping changes.  Is
> > > anything really happening here or have we all given up?
> >
> > Jeff: does that suspend-to-disk hang problem also happen if you use
> > hpet=disable?
> 
> Yes, it is still broken with HPET disabled.
> 
> I've reported that if I press some keys, suspend will complete
> successfully, otherwise, it'll just hang before the "percentage" comes
> on.

Can you please grab the collection of fixups, which I just put into
bugzilla: 

http://bugzilla.kernel.org/attachment.cgi?id=11379&action=view

and apply it on top of 2.6.21 ?

Thanks,

	tglx


