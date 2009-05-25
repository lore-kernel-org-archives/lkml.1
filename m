Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZEYN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZEYN02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZEYN0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:26:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56163 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZEYN0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:26:21 -0400
Date: Mon, 25 May 2009 15:26:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Nigel Cunningham <nigel@tuxonice.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090525132613.GA14096@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <1243243666.16743.64.camel@nigel-laptop> <20090525123228.GA13446@elf.ucw.cz> <200905251522.26852.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905251522.26852.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-05-25 15:22:26, Oliver Neukum wrote:
> Am Montag, 25. Mai 2009 14:32:28 schrieb Pavel Machek:
> > > I'm going to try to. Unfortunately, they'll require what's basically a
> > > group-up redesign of the basic algorithm, because to get maximum
> > > reliability, you need to carefully account for the amount of storage
> > > you're going to need and the amount of memory you have available, and
> > > 'prepare' the image prior to doing the atomic copy.
> >
> > I don't quite get it; why is that needed?
> >
> > If there's not enough swap available, swsusp should freeze, realize
> > there's no swap, unfreeze and continue. I do not see reliability
> > problem there.
> 
> The software suspend may be a part of your response to an imminent
> power failure (UPS near empty). The number of retries available is possibly
> limited.

If there's no swap (and no hibernation partition), s2disk just will
not work.

> I'd feel safer if hibernation by default wrote to a dedicated partition,
> especially as modern practice is to make swap space smaller than RAM.

It would be easy to have dedicated partition. But why waste space on
it?

Anyway, this debate here is "in what order should we do the swsusp
actions". Dedicated partition/etc is for separate thread (please).
 

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
