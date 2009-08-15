Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZHOWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZHOWek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZHOWek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 18:34:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60965 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZHOWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 18:34:39 -0400
Date: Sun, 16 Aug 2009 00:34:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
	userspace-consumer)
Message-ID: <20090815223434.GB27637@elf.ucw.cz>
References: <20090810200553.GB4652@gandalf> <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf> <20090811094020.GA6762@rakim.wolfsonmicro.main> <1249986616.5807.28.camel@odin> <20090811204914.GB13969@gandalf> <20090811223645.GA4691@sirena.org.uk> <20090814163201.GB1626@ucw.cz> <20090815164324.GA4252@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815164324.GA4252@sirena.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-08-15 17:43:24, Mark Brown wrote:
> On Fri, Aug 14, 2009 at 06:32:01PM +0200, Pavel Machek wrote:
> 
> > Please don't put basic fastcharge logic to userspace:
> 
> > * you still want to fastcharge at init=/bin/bash boot
> 
> > * you want to fastcharge while machine is in s2ram. See spitz. Doing
> >   that with userspace would be quite tricky.
> 
> Depending on the technologies involved and how well integrated the power
> path management is with the battery charger fast charge during suspend
> may not actually be desirable.  Some systems need or desire active
> thermal management of the system from the CPU during fast charge.

Do you have example of some system?

Ok, well... anyway many machines _want_ fastcharge while suspended,
and putting charging into userland would break them (or make that
fairly difficult).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
