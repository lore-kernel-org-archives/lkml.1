Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbZHVJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbZHVJ2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 05:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZHVJ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 05:28:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43631 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbZHVJ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 05:28:50 -0400
Date: Sat, 22 Aug 2009 11:28:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
	userspace-consumer)
Message-ID: <20090822092845.GE11448@elf.ucw.cz>
References: <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf> <20090811094020.GA6762@rakim.wolfsonmicro.main> <1249986616.5807.28.camel@odin> <20090811204914.GB13969@gandalf> <20090811223645.GA4691@sirena.org.uk> <20090814163201.GB1626@ucw.cz> <20090815164324.GA4252@sirena.org.uk> <20090815223434.GB27637@elf.ucw.cz> <20090816091858.GB12567@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816091858.GB12567@sirena.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, well... anyway many machines _want_ fastcharge while suspended,
> > and putting charging into userland would break them (or make that
> > fairly difficult).
> 
> Are you sure that's a real need?  Disabling user interaction I can see
> but forcing the system into sleep doesn't seem to be any particular
> benefit - devices like this tend to be designed to appear to be always
> on and clearly when fast charging there's no need to save power
> > which is

At least zaurus sl-3000c is designed like a notebook -- inactive in
s2ram. It is quite old design.

Charging while suspended is preffered, because it allows faster
charge. The machine eats non-trivial power while active, charger is
only 1A, and there's not enough current left for a charge with machine
active.

> the main motiviation for going into suspend.  Also bear in mind that a
> soft SBS system requires constant activity from the CPU for basic
> management of the charge cycle so suspend isn't going to be a real
> option anyway, you'd be suspending for seconds at a time.

Well, if the code is to be useful for something else than SBS... (And
suspending for seconds at a time is okay on zaurus type machines).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
