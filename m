Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbYC1Lov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbYC1Lov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYC1Lom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:44:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58470 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbYC1Lol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:44:41 -0400
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <20080328111334.GD32200@cs181133002.pp.htv.fi>
References: <200803272353.51901.rjw@sisk.pl>
	 <alpine.LFD.1.00.0803281004440.3781@apollo.tec.linutronix.de>
	 <alpine.LFD.1.00.0803281155350.3781@apollo.tec.linutronix.de>
	 <1206702025.8514.624.camel@twins>
	 <20080328111334.GD32200@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 12:44:20 +0100
Message-Id: <1206704661.8514.627.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 13:13 +0200, Adrian Bunk wrote:
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

Are we actually worse off than .24?

I thought group scheduling has been performing less than expected ever
since it got merged.

