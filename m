Return-Path: <linux-kernel-owner+w=401wt.eu-S965512AbXCPQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbXCPQeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965484AbXCPQeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:34:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3018 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933928AbXCPQdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:33:55 -0400
Date: Fri, 16 Mar 2007 16:28:59 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, johann deneux <johann.deneux@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Message-ID: <20070316162858.GB3951@ucw.cz>
References: <2460126662758025813@fi.muni.cz> <d120d5000703070647t223f8858i8c495dcc3e1378a2@mail.gmail.com> <45EEEAA3.50009@gmail.com> <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com> <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com> <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com> <45F722CE.9000602@gmail.com> <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Why did you remove all Cced people? Anyway I filtered 
> >some of them out
> >
> >johann deneux napsal(a):
> >> You are right, the direction in ff_effect is meant to 
> >be an angle.
> >> A dirty solution would be to use the 16 bits as two 
> >8-bits angles. Or
> >
> >That would be a problem as I need 3x 16bits.
> >
> >> maybe we should change the API. I don't think there 
> >are many
> >> applications using force feedback yet, so maybe that 
> >should be ok?
> >>
> >> If we change the API, we should remove the assumption 
> >that a device has
> >> at most two axes to render effects. We could for 
> >instance have a
> >> magnitude argument for each axis which is capable of 
> >rendering effects.
> >> That might be necessary even for more common gaming 
> >devices like racing
> >> wheels: One can think pedals could also be capable of 
> >force feedback
> >> some day, not just the steering wheel.
> >
> >I can do that, but in that case, I need to know how 
> >people (especially those
> >input one) want me to do...
> >
> 
> Since we have no idea how many programs (if any) are 
> using force
> feedback interface I would be wary of changing existing 
> effcets and
> rather add new set of 3D effects.
> 
> Do we have any idea if there any users of FF out there?

Number of linux games is quite low, so...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
