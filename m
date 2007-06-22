Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbXFVAQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbXFVAQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXFVAQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:16:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35927 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbXFVAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:16:17 -0400
Date: Fri, 22 Jun 2007 02:16:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
Message-ID: <20070622001635.GJ23017@stusta.de>
References: <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <alpine.LFD.0.98.0706190732150.3593@woody.linux-foundation.org> <20070619165300.GD19904@flower.upol.cz> <alpine.LFD.0.98.0706190949440.3593@woody.linux-foundation.org> <20070621235117.GD23017@stusta.de> <alpine.LFD.0.98.0706211658270.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211658270.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 04:59:39PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 22 Jun 2007, Adrian Bunk wrote:
> > On Tue, Jun 19, 2007 at 10:04:58AM -0700, Linus Torvalds wrote:
> > >...
> > > This is why I've been advocating bugzilla "forget" stuff, for example. I 
> > > tend to see bugzilla as a place where noise accumulates, rather than a 
> > > place where noise is made into a signal. 
> > > 
> > > Which gets my to the real issue I have: the notion of having a process for 
> > > _tracking_ all the information is actually totally counter-productive, if 
> > > a big part of the process isn't also about throwing noise away.
> > > 
> > > We don't want to "save" all the crud. I don't want "smart tracking" to 
> > > keep track of everything. I want "smart forgetting", so that we are only 
> > > left with the major signal - the stuff that matters. 
> > 
> > Even generating the perfect signal is a complete waste of time if 
> > there's no recipient for the signal...
> 
> My argument is that *if* we had "more signal, less noise", we'd probably 
> get more people looking at it.
> 
> In fact, I guarantee that's the case. You may  not be 100% happy with the 
> regression list, but every single maintainer/developer I've talked to has 
> said they appreciated it and it made it easier (and thus more likely) for 
> them to actually look at what the outstanding issues were.


The problems are the parts of the kernel without maintainer or with a 
maintainer who is for whatever reason not able to look after bug 
reports.

And you often need someone with a good knowledge of a specific area of 
the kernel for getting a bug fixed.


Let me make an example:

During 2.6.16-rc, I reported a bug (not a regression) in CIFS where I 
had reproducible during big writes to a Samba server after some 100 MBs 
(not a fixed amount of data, but 100% reproducible when transferring 1 GB)
a complete freeze of my computer (no SysRq possible). And there is
nothing more I (or any other submitter) could have given as information -
in fact it even took me several days to isolate CIFS as the source of 
these freezes.

Steve French and Dave Kleikamp told me to try some mount option.

With this option, I got an Oops instead of a freeze.

After they fixed the Oops, it turned out the patch also fixed the 
freeze. The patch went into 2.6.16, and it was therefore fixed
in 2.6.16.

That's one important value of maintainers.

In many other parts of the kernel, my bug report wouldn't have had any 
effect.


We need more maintaners who look after bugs - but where to find them, 
they don't seem to grow on trees?


> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

