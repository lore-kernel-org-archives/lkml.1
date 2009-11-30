Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZK3MaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZK3MaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZK3MaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:30:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34847 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZK3MaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:30:05 -0500
Date: Mon, 30 Nov 2009 13:30:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Corentin Chary <corentincj@iksaif.net>, Arve Hj??nnev??g <arve@google.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] staging/android fixes
Message-ID: <20091130123004.GG13328@elf.ucw.cz>
References: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
 <a55d774e0911280219s69729b54l544660aac4b2197@mail.gmail.com>
 <20091129084351.GD1530@ucw.cz>
 <a55d774e0911290138j3d44a25aqce041f7a7a87d5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0911290138j3d44a25aqce041f7a7a87d5a@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> Arve's done a few revisions of the wakelock code with the linux-pm
> >> list, and I know he's planning on trying to work through the remaining
> >> issues (as I recall there was some discussion on read/write vs ioctl
> >> interfaces to userspace) in the near future.
> >>
> >> This really is the one piece that has the most impact on everything
> >> else -- maintaining versions of the various platform hardware drivers
> >> with and without wakelock support is messy.
> >
> > It is really not that bad. Yes, it touches most drivers, but it is few
> > lines per driver and easy to remove.
> >
> > Waiting for wakelocks (1year plus, AFAICT) before merging hw drivers
> > seems like very slow way forward.
> 
> I'm not suggesting we hold off on everything until they're in, just
> saying it'll simplify things once they are.

That's certainly true :-).

> I'd like to get to a point where we can ship out of the upstream
> kernel and that's going to need power management to work.  If we can
> sort out wakelocks (as it seemed like we were getting close to),
> that's one less difference to maintain.

Yes, that would be nice.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
