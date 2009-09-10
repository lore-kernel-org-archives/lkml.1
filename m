Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZIJIXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZIJIXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZIJIXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:23:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40131 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZIJIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:23:17 -0400
Date: Thu, 10 Sep 2009 10:23:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: RFC: Light sensors, unifying current options?
Message-ID: <20090910082312.GG7248@elf.ucw.cz>
References: <4A9FC9D7.20000@cam.ac.uk> <1252308744.3483.414.camel@rzhang-dt> <4AA4F194.1070507@cam.ac.uk> <1252467684.3483.446.camel@rzhang-dt> <4AA79144.8060104@cam.ac.uk> <1252546449.3483.476.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252546449.3483.476.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Perhaps we might do it via sysfs naming instead.
> > 
> > illuminance[n] - defined to be visible (which is what term means anyway)
> > 
> > infrared[n] - hmm.. will be in different units to illuminance - perhaps we leave
> > these raw with suitable documentation?
> > 
> > illuminance_and_infrared[n]
> > 
> what's the unit of this?
> what does the value of this file mean?
> I think we should make sure that there are more sensors need this and
> the same "visible + infrared" reading on different sensors stands for
> the same ambient light environment.

Are you sure that makes sense? And is that even possible? I'd be
afraid that the sensors are not nearly accurate enough to give precise
values, and each sensor is going to take different parts of spectrum,
etc.

Yes, we should aim at having similar interface with similar values on
all the sensors, but lets not overdo it.

> But maybe there are some other sensors that don't have this asynchronous
> notification so that the cached values don't have a chance to get
> updated.
> then we need to read the sensor every time the sysfs I/F is poked.

I bet most sensors are like that. And no, we don't have to reread from
hw every time, we can just read and cache it once per second or
something.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
