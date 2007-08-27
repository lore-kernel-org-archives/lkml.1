Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbXH0MKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbXH0MKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXH0MJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:09:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47647 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756801AbXH0MJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:09:23 -0400
Date: Mon, 27 Aug 2007 11:55:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@gmail.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
Message-ID: <20070827095505.GA1972@elf.ucw.cz>
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com> <6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com> <20070827065246.GA21220@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827065246.GA21220@ime.usp.br>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I didn't know who to include as the wizards of the matter.
> 

> > > If I, on the other hand, use Debian's kernel 2.6.22 or compile my own
> > > kernel with just the necessary parts for my work (version 2.6.23-rc3
> > > taken from kernel.org), then I can't make the machine sleep: when I
> > > press the button, it acts like if I had, in sequence, pressed anything
> > > to wake it up (say, like pressing shift).
> 
> Things are getting now a little bit fishy.
> 
> Before, I was using gnome and all the little daemons that come with it
> (even though I just prefer a plain window manager), but, as I mentioned
> before, it didn't matter if I pressed the power button on X or on a
> console.
> 
> I had the gnomee power-thingy sounding like an alarm (an ambulance!) on me
> when I pressed the power button with Debian kernels 2.6.22, for instance. I
> compiled my own (this time, from kernel.org) 2.6.23-rc3, with many modules
> and subsystems removed (e.g., bluetooth, as this laptop doesn't have it)
> and I got the exact same behavior.
> 
> If I booted, OTOH, with Debian's kernel 2.6.18, things were fine and the
> machine would go to sleep without any problems.
> 
> I am now suspecting of some module that prevented the machine from going to
> sleep and I now using just a fluxbox as my window manager. This time, even
> with a 2.6.23-rc3 kernel (again, from kernel.org) the machine went to sleep
> normally.
> 
> I did 13 compiles with git bisect and some of them were unsucessfuly

Rather than doing bisect, it might be more interesting to find out
which userspace part makes it fail to sleep, then see what is it that
makes the difference.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
