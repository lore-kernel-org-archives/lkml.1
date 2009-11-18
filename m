Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZKRR3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZKRR3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZKRR3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:29:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40013 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921AbZKRR3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:29:36 -0500
Date: Wed, 18 Nov 2009 18:28:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Parsons <lost.distance@yahoo.com>, dtor@mail.ru,
       dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu, linux-kernel@vger.kernel.org,
       Dirk@Opfer-Online.de, arminlitzel@web.de, metan@ucw.cz,
       thommycheck@gmail.com, linux-arm-kernel@lists.infradead.org,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
Message-ID: <20091118172849.GD25150@elf.ucw.cz>
References: <E1NAYJo-00016g-PW@pih-relay04.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NAYJo-00016g-PW@pih-relay04.plus.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-18 00:22:41, Paul Parsons wrote:
> > Does pressure actually work as expected -- that is not inverted?
> > Because I need this patch on spitz...  but it may break your
> > machine...
> 
> You are right, the pressure values were being inverted on my hx4700.
> Pressing hard generates somewhat lower Rt values than pressing lightly.
> 
> Since typical hx4700 Rt values are close to (pressure_max/2) anyway,
> the inverted and non-inverted values were not very different.
> For example:
> 
> Rt      ts->pressure_max-Rt
> 599     425
> 562     462
> 588     436
> 570     454
> 
> So by all means submit your ads7846.c patch; it will not break hx4700.

Dmitry, those pressure values are reverted on more than one machine,
and we do not have anyone reporting it works ok for them. Can we
perhaps just.... fix it?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
