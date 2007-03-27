Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXC0PfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXC0PfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXC0PfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:35:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42014 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbXC0PfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:35:12 -0400
Date: Tue, 27 Mar 2007 08:34:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bryan.wu@analog.com
Cc: Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
Message-Id: <20070327083437.e1d6b954.randy.dunlap@oracle.com>
In-Reply-To: <1174974045.6966.26.camel@roc-desktop>
References: <1174903941.32691.72.camel@roc-desktop>
	<200703262345.09489.arnd@arndb.de>
	<1174966837.6966.13.camel@roc-desktop>
	<20070327035734.GA25883@linux-sh.org>
	<8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>
	<20070327044914.GA26099@linux-sh.org>
	<8bd0f97a0703262217g16aa62d4g1221082deda0aed2@mail.gmail.com>
	<20070326222711.d2f42da2.randy.dunlap@oracle.com>
	<1174974045.6966.26.camel@roc-desktop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 13:40:45 +0800 Wu, Bryan wrote:

> On Mon, 2007-03-26 at 22:27 -0700, Randy Dunlap wrote:
> > On Tue, 27 Mar 2007 01:17:06 -0400 Mike Frysinger wrote:
> > 
> > > On 3/27/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > > > On Tue, Mar 27, 2007 at 12:34:25AM -0400, Mike Frysinger wrote:
> > > > > On 3/26/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > > > > >You should really consider the latter for getting updates merged in the
> > > > > >future
> > > > >
> > > > > we're planning for this, but the short term it isnt doable for us
> > > >
> > > > If you think mangling patches by hand is a more effective use of time, no
> > > > one is stopping you -- some people even prefer that. On the other hand, if
> > > > you're struggling with an effective methodology before things are merged,
> > > > what reason is there to suspect that things will get better afterwards?
> > > 
> > > we have a lot of infrastructure that the SCM is part of and at the
> > > moment, git is not a supported SCM
> > > 
> > > i'm not saying the current system is easy, just that we cant integrate
> > > git in the short term, so we'll continue spanking Bryan with the
> > > overhead :/
> > 
> > In that case, Bryan may like to know that git, mercurial (IIRC),
> > and quilt have patchbomb tools.  Also GregKH has one somewhere (he
> > can tell you where).  And Paul Jacksone has one at
> >   http://www.speakeasy.org/~pj99/sgi/sendpatchset
> > 
> 
> Thanks for this guide line information. I will dig into it.
> 
> But in my experience, it is difficult to find right patch email
> receivers, even in the MAINTAINERS file. If there are 20 patch emails,
> we should find 20 email receivers at least and manually add them to the
> emails. This is terrible, right? Any idea?

Yes, well, we all have the honor of going thru that.  There have
been a few suggestions, but I haven't seen any that were Real Good IMO.

You'll learn (quickly) where most patches go (i.e., subsystems and
their major maintainers/contributors).  Just put those people into
your email client address book and into the patch descriptions, like
Sam said, so that the patchbomb tools can help you out with them.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
