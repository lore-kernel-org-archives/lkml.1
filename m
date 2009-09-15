Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZIOKta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZIOKta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZIOKt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:49:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42002 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZIOKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:49:25 -0400
Date: Tue, 15 Sep 2009 12:49:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, Marek Vasut <marek.vasut@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090915104919.GE19989@elf.ucw.cz>
References: <20090913230008.GC30169@n2100.arm.linux.org.uk> <20090914002100.GD30621@shareable.org> <20090914081001.GB14519@n2100.arm.linux.org.uk> <94a0d4530909140558nd8d2c47lc9954563c80a574f@mail.gmail.com> <20090914140059.GC21580@n2100.arm.linux.org.uk> <94a0d4530909140738t7e4d646r134cfd884da21348@mail.gmail.com> <20090914144028.GG21580@n2100.arm.linux.org.uk> <94a0d4530909140814w36f7f5f0td2c25db07fbd4e57@mail.gmail.com> <20090915103739.GA19519@elf.ucw.cz> <94a0d4530909150347h642772bvc8175109393e905f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94a0d4530909150347h642772bvc8175109393e905f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-15 13:47:01, Felipe Contreras wrote:
> On Tue, Sep 15, 2009 at 1:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> >> >> > Because then you get it whenever you configure for V4 as the lowest
> >> >> > denominator CPU, which leads to the buggy behaviour on better CPUs.
> >> >> > It's far better to leave it as is and just accept that the old CPUs
> >> >> > will have longer than necessary delays.  If people really really
> >> >> > care (and there's likely to only be a small minority of them now)
> >> >> > changing the '0' to a '1' is a very simple change for them to carry
> >> >> > in their local tree.  Unlike getting the right unrolling etc.
> >> >>
> >> >> Well, they can also 'git revert' this patch. If somebody really cares
> >> >> I think they should shout now and provide a better patch, otherwise
> >> >> this one should be merged.
> >> >
> >> > On the other hand, having the code there as it currently stands is not
> >> > harmful in any way, so leaving it there is just as easy.
> >>
> >> It makes the code less understandable. I'm not sure about linux's
> >> practices, but an #if 0 generally means somebody is being lazy.
> >
> > Not in this case, as you was explained to you. You may want to add
> > explaining comment above #if 0....
> 
> Yes, but I've no idea in which situations somebody might want to
> enable that code. Old chips? Which old chips?

If you udelay() produces too long delays, as was explained in the thread. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
