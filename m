Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZLMNTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZLMNTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZLMNTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:19:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44675 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753047AbZLMNTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:19:31 -0500
Date: Sun, 13 Dec 2009 14:19:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091213131921.GA1437@ucw.cz>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se> <20091204104930.GA28625@sirena.org.uk> <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se> <20091207114825.GA26965@rakim.wolfsonmicro.main> <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One of the things we're facing is Android, which has
> its userspace in plain Java JNI at the end of this link:
> http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob;f=s
> ervices/jni/com_android_server_BatteryService.cpp;h=8e7cadc6b680fc420d34
> 1faa094c71922946fdab;hb=HEAD
> 
> If you browse down to line 275 you can see it parse the sysfs
> attribute "capacity", then this propagates up to the battery
> status indicator on *all* Android phones out there. So if
> you want to run Android unmodified, this is what you need to
> provide. They are effectively using the power sysfs as
> their hardware abstraction layer in this case.
> 
> Note: I'm not claiming that Android is doing it right or that
> we can't modify this code or so, it's just that this is the way
> a few million Android devices out there are actually doing it.

Users can't modify them, so they don't count...

...but then there are all the systems that rely on /proc/apm
emulation, like openembedded popular on sharp zaurus...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
