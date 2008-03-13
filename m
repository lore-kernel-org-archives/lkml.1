Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbYCMFmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbYCMFmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 01:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYCMFmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 01:42:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:49065 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751139AbYCMFmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 01:42:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18h3eUsyxIhwfPaJUiGvqQRAowz/MbbyxmFb9OHOS
	LPF1B+pP2pbtUg
Subject: Re: Keys get stuck
From: Mike Galbraith <efault@gmx.de>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Fred ." <eldmannen@gmail.com>
In-Reply-To: <200803122222.05663.hpj@urpla.net>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
	 <47D8091E.6030906@davidnewall.com>
	 <Pine.LNX.4.64.0803121748140.15209@jikos.suse.cz>
	 <200803122222.05663.hpj@urpla.net>
Content-Type: text/plain; charset=utf-8
Date: Thu, 13 Mar 2008 06:42:13 +0100
Message-Id: <1205386933.4797.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 22:22 +0100, Hans-Peter Jansen wrote:
> Am Mittwoch, 12. März 2008 schrieb Jiri Kosina:
> > On Thu, 13 Mar 2008, David Newall wrote:
> > > > The problem is that under heavy load the auto-repeat problem is real;
> > > > I've seen it as well, and it means that I've started to try to avoid
> > > > "make -j4" since that's a great way to trigger it.
> > >
> > > I'm sure it does suck under heavy load, although I suppose you could
> > > increase the start time.  But I wonder if that is the problem this
> > > time?  Modern machines are so damned fast they actually take real
> > > effort to load.  Actually, "make -j4" doesn't sound particularly heavy.
> > > There's huge disk i/o in a make.  Plenty of scheduling opportunities.
> > > Obviously I only know what everybody else here knows; but with so many
> > > recent posts suggesting a scheduling fault has been introduced, I'm
> > > expecting it to be that.
> >
> > The problem became much more apparent during early -rc phase of 2.6.25
> > for those people that have CONFIG_GROUP_SCHED turned on. This clearly
> > shows that X are somehow unhappy with how kernel schedules them, but I
> > don't have idea how autorepeat is implemented inside X and what could be
> > the problem right now.
> 
> Just for the record, this problem started with openSUSE 10.2 for me, that's 
> a 2.6.18 thingy. I'm a heavy xterm user, where the autorepeat gets a life 
> of its own _occasionally_. I'm able to stop it by triggering a autorepeat 
> manually (typical antidot reaction).

I've seen these key repeats for years.  All I ever had to do was to make
X run heavily enough in the presence of another (hefty) load that it
hits the expired array and thereby takes a serious latency hit.  I
always considered key repeats under load to be X's quaint way of saying
"HEEEEELP MEEEE" ;-)

	-Mike

