Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXGYWrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXGYWrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbXGYWrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:47:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48932 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756276AbXGYWq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:46:59 -0400
Date: Thu, 26 Jul 2007 00:47:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: MMC/SD Root filesystem suspend/resume problems
Message-ID: <20070725224710.GB8950@elf.ucw.cz>
References: <1184860419.29634.10.camel@localhost.localdomain> <20070719190309.28708be8@poseidon.drzeus.cx> <1185110313.6819.8.camel@localhost.localdomain> <20070725190115.GB10208@ucw.cz> <1185391242.6190.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185391242.6190.17.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-07-25 20:20:42, Richard Purdie wrote:
> On Wed, 2007-07-25 at 19:01 +0000, Pavel Machek wrote:
> > > I enabled the MMC_UNSAFE_RESUME option and the problems I was seeing was
> > > "fixed". I think having this option is a bad idea (in its current form)
> > > as it doesn't actually stop filesystem corruption.
> > > 
> > > With the option disabled, if a filesystem is mounted when you suspend my
> > > tests show the filesystem is corrupted. At least if the option is
> > > enabled, the filesystem is only corrupted if you remove the card whilst
> > > suspended which is more preferable.
> > 
> > Are we talking _corruption_ here, or are we talking 'the kind of
> > corruption recoverable by fsck that happens on powerfail'?
> 
> There was more damage to the system than just a dirty bit set. Yes, fsck
> could fix it but I don't think it should happen in the first place...

Well, that's "ok", that happens on sudden powerdowns, too.

(Well, but we do sync() during suspend, so it is a bit strange). Do
you have fsck logs perhaps?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
