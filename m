Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbZJIOt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbZJIOt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761019AbZJIOt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:49:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:45597 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760824AbZJIOt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:49:27 -0400
Date: Fri, 9 Oct 2009 07:48:40 -0700
From: Greg KH <gregkh@suse.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
Message-ID: <20091009144840.GA9561@suse.de>
References: <20091007185112.GJ7899@atomide.com> <94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com> <20091008214140.GJ7417@atomide.com> <94a0d4530910081513w1a919dc2s50eca41966a2261d@mail.gmail.com> <94a0d4530910081520t66ce7567xe142979a35b1245@mail.gmail.com> <20091008232603.GB25892@atomide.com> <94a0d4530910090508o1e3d19cew881d2eb348199674@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a0d4530910090508o1e3d19cew881d2eb348199674@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 03:08:00PM +0300, Felipe Contreras wrote:
> On Fri, Oct 9, 2009 at 2:26 AM, Tony Lindgren <tony@atomide.com> wrote:
> > * Felipe Contreras <felipe.contreras@gmail.com> [091008 15:20]:
> 
> <snip/>
> 
> >> > Here you can see Uwe Kleine-K??nig sending the original patch without
> >> > even CC'ing the mmc list:
> >> > http://marc.info/?l=linux-kernel&m=124820861213849&w=2
> >> >
> >> > And it was unintentionally broken by this one:
> >> > http://marc.info/?l=linux-mmc&m=125249763422227&w=2
> >>
> >> Er, actually that one was ok, the problem was introduced only in the
> >> final version:
> >> http://marc.info/?l=linux-mmc&m=125366315417006&w=2
> >
> > Right, looks like Roger forgot to Cc linux-mmc.
> >
> >> > I don't see what we are waiting for, the code is clearly broken, even
> >> > the compiler warns that nobody is using omap_hsmmc_probe().
> >
> > I've sent Roger's patch to Andrew & linux-mmc so hopefully it will get
> > merged soon:
> >
> > http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg00539.html
> 
> I don't see what's specific about mmc in that patch, nor omap. It's
> just a fix for an obvious mistake that must be picked ASAP and can't
> possibly be NAK'ed.
> 
> There's a tree for trivial fixes:
> git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
> 
> And one for includecheck:
> git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6
> 
> What's the procedure for obvious fixes? I'm CC'ing Greg KH and Andrew
> Morton because I think they might interested in fixing these kinds of
> issues quickly in the future.

What kind of issues?  Why would I be interested, where is the problem?

confused,

greg k-h
