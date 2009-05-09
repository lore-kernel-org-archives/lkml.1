Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZEINDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZEINDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZEINDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:03:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42238 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEINDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:03:44 -0400
Date: Sat, 9 May 2009 15:03:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090509130338.GB10859@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507215112.GC14611@elf.ucw.cz> <1241746459.19600.246.camel@nigel-laptop> <200905081611.41865.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905081611.41865.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Actually, I see advantages of working together versus fighting flame wars.
> > > > Please stop that, I'm not going to take part in it this time.
> > > 
> > > Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
> > > having swsusp,uswsusp *and* tuxonice to maintain? I hope not.
> > > 
> > > If we are talking about improving mainline to allow tuxonice
> > > functionality... then yes, that sounds reasonable.
> > 
> > I'd like to see use have all three for one or two releases of vanilla,
> > just to give time to work out any issues that haven't been foreseen.
> > Once we're all that there are confident there are no regressions with
> > TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.
> 
> So this is an idea to replace our current hibernation implementation with
> TuxOnIce.
> 
> Which unfortunately I don't agree with.
> 
> I think we can get _one_ implementation out of the three, presumably keeping
> the user space interface that will keep the current s2disk binaries happy, by
> merging TuxOnIce code _gradually_.  No "all at once" approach, please.
> 
> And by "merging" I mean _exactly_ that.  Not adding new code and throwing
> away the old one.
> 
> While I can work on creating one hibernation implementation by taking the
> best ideas from all of the implementation we have at hand, I surely won't be
> working on replacing our current code with TuxOnIce.  If that disappoints you,
> then I'm sorry.

FWIW, I agree with Rafael here. Improving the current code in
reasonable steps is the way to go.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
