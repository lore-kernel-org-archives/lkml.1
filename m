Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYGGI7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYGGI7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 04:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYGGI70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 04:59:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40976 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYGGI7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:59:25 -0400
Date: Mon, 7 Jul 2008 11:58:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080707085836.GL21669@cs181140183.pp.htv.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <200807062002.46863.rjw@sisk.pl> <20080706182648.GE21669@cs181140183.pp.htv.fi> <200807062304.07443.rjw@sisk.pl> <20080706213214.GH21669@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0807061443420.3016@woody.linux-foundation.org> <20080706221932.GJ21669@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0807061524510.3016@woody.linux-foundation.org> <20080706230610.GK21669@cs181140183.pp.htv.fi> <87skumr2jg.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87skumr2jg.fsf@saeurebad.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 01:55:15AM +0200, Johannes Weiner wrote:
> Hi,
> 
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > On Sun, Jul 06, 2008 at 03:27:30PM -0700, Linus Torvalds wrote:
> >> 
> >> 
> >> On Mon, 7 Jul 2008, Adrian Bunk wrote:
> >> >
> >> > When did you tell me that maintainers should not or cannot be Cc'ed on 
> >> > regression reports?
> >> 
> >> That is not what I'm complaining about.
> >
> > That is what I wrote in the part of my email you made this comment on.
> >
> >> I'm complaining about the fact that you *always* argue against closing 
> >> bugreports.
> >
> > I'm not always against closing bugs, and e.g. during the last years I've
> > closed at about 500 bugs in the kernel Bugzilla due to submitters having
> > vanished.
> >
> >> You have argued against it for over a YEAR now. And every single time I 
> >> tell you that you are wrong, and exactly *why* you are wrong.
> >> 
> >> If a reporter doesn't respond to say "it's still open", it needs to be 
> >> closed. It doesn't matter one whit whether there has been developer action 
> >> on it or not. We cannot keep old reports open - it's a total waste for 
> >> developers to even _look_ at anything that is more than roughly a month 
> >> old and hasn't been verified to be still be an issue.
> >
> > We only differ on whether a human should ask this question once before 
> > closing a bug or whether regular automated requests are enough.
> 
> I prefer being bugged regularly as a reporter.  At the moment I have a
> bug at a machine I do not use every day and if I get this email, it
> reminds me to test the latest kernel on that machine (or try to
> reproduce the bug if it happens in situations not common in my usual
> workflow).  Then I report back.

It often depends on the kind of bug.

E.g. if you reported "my main computer crashes twice a day" you would be 
more interested to see some developer actually working on it before 
reproducing it weekly.

> If these remainders weren't, it would be possible that I forget about a
> bug and come back to it when it's a real pain to hunt it down by
> change-history or when a possible cause for the bug has left the
> developers mind a long time ago.

You get me wrong.

I'm not saying the automated reminders should vanish.

But before closing a bug as "reported does not respond" IMHO a manual 
request should be done first.

Otherwise we get people into the "I reported a bug, got only automated 
emails, and the only action by the developers was to close the bug once 
I got too annoyed to answer weekly that it's still present." situation.

> 	Hannes

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

