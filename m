Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZHVLpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZHVLpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 07:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbZHVLpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 07:45:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39811 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbZHVLpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 07:45:44 -0400
Date: Fri, 21 Aug 2009 16:01:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
	userspace-consumer)
Message-ID: <20090821140126.GA1328@ucw.cz>
References: <20090811094020.GA6762@rakim.wolfsonmicro.main> <1249986616.5807.28.camel@odin> <20090811204914.GB13969@gandalf> <20090811223645.GA4691@sirena.org.uk> <20090814163201.GB1626@ucw.cz> <20090815164324.GA4252@sirena.org.uk> <20090815223434.GB27637@elf.ucw.cz> <20090816091858.GB12567@sirena.org.uk> <20090822092845.GE11448@elf.ucw.cz> <20090822101641.GC4344@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090822101641.GC4344@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-08-22 11:16:42, Mark Brown wrote:
> On Sat, Aug 22, 2009 at 11:28:45AM +0200, Pavel Machek wrote:
> 
> > At least zaurus sl-3000c is designed like a notebook -- inactive in
> > s2ram. It is quite old design.
> 
> > Charging while suspended is preffered, because it allows faster
> > charge. The machine eats non-trivial power while active, charger is
> > only 1A, and there's not enough current left for a charge with machine
> > active.
> 
> Like you say this is a very old design but even there I'm fairly
> surprised it's causing issues when charging from a wall supply.  If
> you're charging from USB then there is obviously a constraint on the
> power draw but normally a modern system has sufficiently low power draw
> when idle that it's not actually a big deal - runtime power management
> facilities have improved greatly.

Well... all the hardware I have here (zaurus, openmoko, htc dream) has
issues with power consumption while charging... so I do not think
runtime pm is solved problem.

> There's also the fact that if you're completely reliant on the CPU to
> control the charger you have to be very sure that the system will come
> back from suspend reliably due to the risk of hardware damage.  The
> hardware should have safety features to prevent serious problems but
> it's a consideration.

While crashes during suspend/resume are common on pcs, embedded
systens do better. And crashes during runtime happen, too.

First, I can't imagine system where you can damage the battery by just
crashing sw. 4.2 per cell voltage limit is just too easy to do in
hw. Maybe if you crash the sw then bring the machine outside while its
stil on charger and theres 110F outside...

And yes it should have safety features, and if they are not there its
broken hw.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
