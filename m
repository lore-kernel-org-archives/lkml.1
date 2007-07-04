Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbXGDTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbXGDTdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXGDTdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:33:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39583 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754309AbXGDTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:33:36 -0400
Date: Wed, 4 Jul 2007 21:33:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: seife@suse.de, nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       suspend-devel@lists.sourceforge.net
Subject: Re: [RFC] get rid of CONFIG_DISABLE_CONSOLE_SUSPEND
Message-ID: <20070704193313.GF2728@elf.ucw.cz>
References: <20070628135108.GA1810@elf.ucw.cz> <200706281734.54642.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706281734.54642.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > What about this? (Only compile tested, but looks pretty obvious to
> > me). Something like this should get us rid of ugly option, and still
> > solve debugging problems... Hmmm?
> > 								Pavel
> > 
> > Kill CONFIG_DISABLE_CONSOLE_SUSPEND; it should not be configurable at
> > all, instead, we should automatically keep console alive when
> > possible.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/drivers/char/lp.c b/drivers/char/lp.c
> > index 62051f8..8267ff8 100644
> > --- a/drivers/char/lp.c
> > +++ b/drivers/char/lp.c
> > @@ -144,7 +144,7 @@ static unsigned int lp_count = 0;
> >  static struct class *lp_class;
> >  
> >  #ifdef CONFIG_LP_CONSOLE
> > -static struct parport *console_registered; // initially NULL
> > +static struct parport *console_registered;
> >  #endif /* CONFIG_LP_CONSOLE */
> 
> Could you please avoid fixing things like this, white space etc. in this patch?
> It would be easier to read ...

Yep, sorry, it should be separate patch. I hope the idea is still
simple enough.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
