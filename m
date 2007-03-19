Return-Path: <linux-kernel-owner+w=401wt.eu-S966018AbXCSPcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966018AbXCSPcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966016AbXCSPcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:32:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38440 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965885AbXCSPcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:32:46 -0400
Date: Mon, 19 Mar 2007 16:32:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Message-ID: <20070319153222.GF1915@elf.ucw.cz>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070226220152.GA29575@stusta.de> <20070228211318.GB4301@mellanox.co.il> <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com> <20070305000421.GF3441@stusta.de> <b6a2187b0703051732v79a532f6mbf0d3da857a914e6@mail.gmail.com> <b6a2187b0703060403o48130853m9393df70160303c1@mail.gmail.com> <20070306120808.GA9537@mellanox.co.il> <b6a2187b0703060412l66fe8db8l12e5403821d1438b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0703060412l66fe8db8l12e5403821d1438b@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >> > > > I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
> >> > > > from RAM, can't suspend to disk. It is possible to revert all the
> >> > > > changes to ACPI and test it?
> >> > >
> >> > > This is with CONFIG_KVM=n?
> >> >
> >> > Yes.
> >>
> >> I've tried with CONFIG_KVM=n and CONFIG_KVM=y and both does not suspend.
> >
> >Do you mean that they "do not resume after suspend"?
> 
> I can't even suspend to disk/ram. It just hangs and the lights just
> blink and everything else hangs. With 2.6.20, it works fine.

Turn up console loglevel, and see where it hangs...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
