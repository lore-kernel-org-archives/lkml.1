Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXFNRap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXFNRap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFNRah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:30:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35081 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305AbXFNRah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:30:37 -0400
Date: Thu, 14 Jun 2007 19:30:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070614173049.GU3588@stusta.de>
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <46715FD4.6040803@s5r6.in-berlin.de> <20070614163923.GM7266@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070614163923.GM7266@flower.upol.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 06:39:23PM +0200, Oleg Verych wrote:
> On Thu, Jun 14, 2007 at 05:33:40PM +0200, Stefan Richter wrote:
> []
> > [...]
> > > Why you didn't proposed (used) Debian's BTS as alternative to bugzilla,
> > [...]
> > 
> > BTS has been mentioned in that thread in a few posts; mostly positively
> > as I recall.
> 
> I know, that most developers here are not working/familiar with what
> Debian has as its bug shooting weapon ``The system is mainly controlled
> by  e-mail, but the bug reports can be viewed using the WWW.''[0].
> 
> I thought somebody, who familiar with that, might propose to setup/tune
> it, but not doing yet another NIH thing, especially from e-mail
> integration POV. I doubt mozilla guys can think about it without
> javascript and/or java servlets :)
>...

The problem isn't Bugzilla, and the Debian BTS wouldn't solve any 
problem.

What is missing?

We need people who know one or more subsystems and who are willing to 
regularly handle bug reports in their area.

And we need a release process that makes debugging, and if possible 
fixing, all regressions prior to the release mandatory. You might never 
come down to zero regressions and might not be able to handle all 
last-minute reported regressions, but the 2.6.21 situation with 3 week 
old known regressions not ever being debugged by a kernel developer 
before the release has much room for improvements.

Changing the BTS would make sense if some core developers would state 
that they would start using the BTS after this change. But otherwise it 
doesn't matter which BTS to use.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

