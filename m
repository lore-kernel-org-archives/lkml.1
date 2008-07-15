Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbYGOSEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbYGOSEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYGOSEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:04:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbYGOSEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:04:42 -0400
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
From: Dan Williams <dcbw@redhat.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Michael Buesch <mb@bu3sch.de>,
       Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1216144711.13411.18.camel@localhost.localdomain>
References: <20080709190915.GA8238@tuxdriver.com>
	 <69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
	 <200807101815.27204.mb@bu3sch.de>
	 <1216142191.6039.113.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0807151323570.12484@xanadu.home>
	 <1216144711.13411.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Tue, 15 Jul 2008 14:02:48 -0400
Message-Id: <1216144968.13411.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 13:58 -0400, Dan Williams wrote:
> On Tue, 2008-07-15 at 13:31 -0400, Nicolas Pitre wrote:
> > On Tue, 15 Jul 2008, Dan Williams wrote:
> > 
> > > On Thu, 2008-07-10 at 18:15 +0200, Michael Buesch wrote:
> > > > On Thursday 10 July 2008 18:12:32 Stefanik Gábor wrote:
> > > > > Some other topics which might be of interest/good to include:
> > > > > - New chipsets needing drivers (SiS 16x, Marvell, etc.)
> > > > 
> > > > I have no idea what to discuss about non-existing drivers, really.
> > > > Something like: "Do we need that driver? Everyone votes YES and is happy"?
> > > 
> > > Maybe during the week we could organize some hackfests to work on the
> > > Marvell/SiS/etc mac80211 drivers?  Everyone bring their favorite
> > > non-working Marvell 88w83xx card and we make mrv8k our bitch or
> > > something like that.
> > 
> > FYI...
> > 
> > Lennert Buytenhek and I are writing a GPL driver for mv8300 class of 
> > Marvell WIFI chips right now, present and future versions. This is 
> > Marvell work as we work for Marvell.  I have access to firmware sources, 
> > etc. but obviously cannot share them.
> > 
> > We both will be in Ottawa next week.
> 
> Great!  Lets definitely sit down and talk then.  There is already some
> GPL-ed source code for 83xx chips out there but it always used net80211,
> not mac80211.  So the mrv8k effort is meant to write a mac80211 driver
> for 8310/8335/etc and perhaps TopDog chips too since they don't seem
> that much different from a driver perspective.
> 
> Some of the issues with the current Marvell 83xx GPL drivers that have
> gotten out are (a) code style, (b) lots of commented out stuff that's
> never used, (c) OS abstraction that's unnecessary on Linux, (d) doesn't
> use mac80211, and (e) uses private ioctls.  So hopefully you're writing
> a new 83xx driver from scratch :)
> 
> We cleaned up a lot of stuff for the OLPC 8388 libertas driver, but
> unfortunately we never were able to get the Marvell 8388 team onboard,
> and so they just went off and kept working on their driver and didn't
> really move the upstream libertas driver forward at all.

Forgot to finish this last bit...

So hopefully that won't happen here, since this would be pretty much the
same situation up to this point.  Ideally you can get the internal
Marvell developers onboard so we're all working on essentially the same
bits, exactly like Intel has done.  Yeah, they develop on private trees
internally but at the end of the day, their base code is the same
upstream base code everyone else uses.

Dan

