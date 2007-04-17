Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbXDQISM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbXDQISM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXDQISL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:18:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43298 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752820AbXDQISK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:18:10 -0400
Date: Tue, 17 Apr 2007 10:17:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matt Reimer <mattjreimer@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: Re: [PATCH 6/7] [RFC] ds2760 battery driver
Message-ID: <20070417081758.GA4908@elf.ucw.cz>
References: <20070411232522.GF20095@zarina> <20070415194001.GF10097@ucw.cz> <f383264b0704161214x168b36f4tdd9a074d604b36cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f383264b0704161214x168b36f4tdd9a074d604b36cb@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> +     /* Calculate the empty level at the present temperature. */
> >> +     scale[4] = di->raw[DS2760_ACTIVE_EMPTY + 4];
> >> +     for (i = 3; i >= 0; i--)
> >> +             scale[i] = scale[i + 1] + di->raw[DS2760_ACTIVE_EMPTY + i];
> >> +
> >> +     di->empty_mAh = battery_interpolate(scale, di->temp_C / 10);
> >
> >Wow.
> 
> Yeah, mea culpa. I don't like its obtuseness either, and haven't
> revisited it since I got it working. Basically the battery has an

No, I actually like the fact that someone cared enough about
temperature's influence on li-ion.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
