Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbXFNUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbXFNUVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbXFNUVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:21:16 -0400
Received: from barikada.upol.cz ([158.194.242.200]:60693 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXFNUVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:21:15 -0400
Date: Thu, 14 Jun 2007 22:33:38 +0200
To: Adrian Bunk <bunk@stusta.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070614203338.GN7266@flower.upol.cz>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <46715FD4.6040803@s5r6.in-berlin.de> <20070614163923.GM7266@flower.upol.cz> <20070614173049.GU3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614173049.GU3588@stusta.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 07:30:49PM +0200, Adrian Bunk wrote:
> On Thu, Jun 14, 2007 at 06:39:23PM +0200, Oleg Verych wrote:
[]
> > I know, that most developers here are not working/familiar with what
> > Debian has as its bug shooting weapon ``The system is mainly controlled
> > by  e-mail, but the bug reports can be viewed using the WWW.''[0].
> > 
> > I thought somebody, who familiar with that, might propose to setup/tune
> > it, but not doing yet another NIH thing, especially from e-mail
> > integration POV. I doubt mozilla guys can think about it without
> > javascript and/or java servlets :)
> >...
> 
> The problem isn't Bugzilla, and the Debian BTS wouldn't solve any 
> problem.
> 
> What is missing?
> 
> We need people who know one or more subsystems and who are willing to 
> regularly handle bug reports in their area.

I think if somebody, by example will show how it can be handled in more
convenient way, that will eventually become mainstream. As we know,
nothing gets from vacuum just like that, without taking energy and time.
And my question was not about this social problem of acceptance, support
etc.

Linus had spent some time in this thread trying to explain what problems
are: as from that (social, think scheduler :) POV, as also from
"zarro bogs found" one.

Also, after i saw Linus' message about doing mostly tools last couple of
years, i wonder why you, Adrian, didn't think about your tools first,
before you've started regression tracking? You are not running in front
of a train, unlike you know who does, plus bugzilla issues are known for
years. Luckily Fedora kernel guys also upstream developers, thus lkml and
other MLs under their view.

After having read all that, i've asked you, my question, as the person
who supposedly used BTS as a maintainer.

Yes, in current form it might not be in suitable configuration, i.e.
kernel sub-systems instead of packages etc, anyway main thing is the way
BTS is handled. While i was looking and replying for bug reports in the
Debian kernel, that i saw in lkml, i've noticed, just how guys work with
it there. Now they even came up with tracking upstream bugzilla, it
seems [0]. I left that activity due to RL some months ago, but now trying
to catch up things again.

Thus it's just my curiosity about all this. And BTS is like, you know,
why not, if it fits by mostly all parameters?

[0] Message-ID: <handler.s.C.118074292516912.transcript@bugs.debian.org>
    Xref: news.gmane.org gmane.linux.debian.devel.kernel:29426
    Archived-At: <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29426>


> And we need a release process that makes debugging, and if possible 
> fixing, all regressions prior to the release mandatory. You might never 
> come down to zero regressions and might not be able to handle all 
> last-minute reported regressions, but the 2.6.21 situation with 3 week 
> old known regressions not ever being debugged by a kernel developer 
> before the release has much room for improvements.
> 
> Changing the BTS would make sense if some core developers would state 
> that they would start using the BTS after this change. But otherwise it 
> doesn't matter which BTS to use.

So, as i've wrote before: one must give them pretty-shiny tool, kindly
barking in their inboxes, instead of for example

"Guilty: **** ***** <????@****.com>",

as it was on the very beginning.
____
