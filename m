Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbZKRRqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbZKRRqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZKRRqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:46:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52144 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbZKRRqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:46:02 -0500
Date: Wed, 18 Nov 2009 18:46:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
Message-ID: <20091118174602.GH25150@elf.ucw.cz>
References: <E1NAYJo-00016g-PW@pih-relay04.plus.net>
 <20091118172849.GD25150@elf.ucw.cz>
 <20091118173934.GA4458@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118173934.GA4458@core.coreip.homeip.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-18 09:39:34, Dmitry Torokhov wrote:
> On Wed, Nov 18, 2009 at 06:28:49PM +0100, Pavel Machek wrote:
> > On Wed 2009-11-18 00:22:41, Paul Parsons wrote:
> > > > Does pressure actually work as expected -- that is not inverted?
> > > > Because I need this patch on spitz...  but it may break your
> > > > machine...
> > > 
> > > You are right, the pressure values were being inverted on my hx4700.
> > > Pressing hard generates somewhat lower Rt values than pressing lightly.
> > > 
> > > Since typical hx4700 Rt values are close to (pressure_max/2) anyway,
> > > the inverted and non-inverted values were not very different.
> > > For example:
> > > 
> > > Rt      ts->pressure_max-Rt
> > > 599     425
> > > 562     462
> > > 588     436
> > > 570     454
> > > 
> > > So by all means submit your ads7846.c patch; it will not break hx4700.
> > 
> > Dmitry, those pressure values are reverted on more than one machine,
> > and we do not have anyone reporting it works ok for them. Can we
> > perhaps just.... fix it?
> 
> OK, so we have 4 instances where pressure is inverted and nobody wants
> to come out with a non-inverted example... I'll queue for .33 then - .32
> it too close to the release.

Yes, .33 makes sense. Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
