Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbYBDTwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbYBDTwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYBDTwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:52:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38725 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755455AbYBDTwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:52:36 -0500
Date: Mon, 4 Feb 2008 20:52:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Abel Bernabeu <abel.bernabeu@gmail.com>
Cc: mingo@elte.hu, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: brk randomization breaks columns
Message-ID: <20080204195251.GB4915@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu> <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz> <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz> <15577be70802041016m97cddbfk43b9073408bcbce9@mail.gmail.com> <15577be70802041029o2975ba6do34589bbdc81d1652@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15577be70802041029o2975ba6do34589bbdc81d1652@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > > I still don't seem to fully understand what is happening here --
> > > aparently this is triggerable only with old programs linked against
> > > libc.so.5, and I am not able to trigger it with my trivial program when
> > > I link it against old libc.so.5, which just basically does brk() and
> > > checks whether /proc/<pid>/maps are OK. Seems to me that (at least
> > > certain versions) of libc.so.5 (wrongly) assume that end of the bss is
> > > the start of the heap, but I will try to investigate it more.
> 
> I think I am getting the some problem with brand new binaries produced
> by myself :(
> 
> Look at this report I posted days ago:
> 
> http://marc.info/?l=linux-kernel&m=120169141603789&w=2

Your crash is in kernel, no? Anyway, I can workaround mine by
disabling randomization...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
