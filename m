Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbXFNUqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbXFNUqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXFNUp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:45:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35300 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750890AbXFNUp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:45:57 -0400
Date: Thu, 14 Jun 2007 22:46:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070614204610.GV3588@stusta.de>
References: <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <46715FD4.6040803@s5r6.in-berlin.de> <20070614163923.GM7266@flower.upol.cz> <20070614173049.GU3588@stusta.de> <20070614203338.GN7266@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070614203338.GN7266@flower.upol.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 10:33:38PM +0200, Oleg Verych wrote:
>...
> Also, after i saw Linus' message about doing mostly tools last couple of
> years, i wonder why you, Adrian, didn't think about your tools first,
> before you've started regression tracking? You are not running in front
> of a train, unlike you know who does, plus bugzilla issues are known for
> years. Luckily Fedora kernel guys also upstream developers, thus lkml and
> other MLs under their view.

My tool was a textfile with a text editor.
For a smaller amount of regressions that works fine.

And it's not that Linus started developing the Linux kernel with writing 
git, the first 10 years of Linux development were without any SCM.

> After having read all that, i've asked you, my question, as the person
> who supposedly used BTS as a maintainer.
> 
> Yes, in current form it might not be in suitable configuration, i.e.
> kernel sub-systems instead of packages etc, anyway main thing is the way
> BTS is handled. While i was looking and replying for bug reports in the
> Debian kernel, that i saw in lkml, i've noticed, just how guys work with
> it there. Now they even came up with tracking upstream bugzilla, it
> seems [0]. I left that activity due to RL some months ago, but now trying
> to catch up things again.
>...

Both the Debian BTS and Bugzilla are usable programs with their own
advantages and disadvantages.

I don't believe switching to the Debian BTS would solve any problem.

> > And we need a release process that makes debugging, and if possible 
> > fixing, all regressions prior to the release mandatory. You might never 
> > come down to zero regressions and might not be able to handle all 
> > last-minute reported regressions, but the 2.6.21 situation with 3 week 
> > old known regressions not ever being debugged by a kernel developer 
> > before the release has much room for improvements.
> > 
> > Changing the BTS would make sense if some core developers would state 
> > that they would start using the BTS after this change. But otherwise it 
> > doesn't matter which BTS to use.
> 
> So, as i've wrote before: one must give them pretty-shiny tool, kindly
> barking in their inboxes, instead of for example
> 
> "Guilty: **** ***** <????@****.com>",
> 
> as it was on the very beginning.

A pretty-shiny tools wouldn't change anything.

What you need are humans debugging the regresssions and humans remining 
other humans that they should debug the regressions.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

