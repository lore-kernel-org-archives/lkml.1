Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZEVOJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZEVOJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZEVOJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:09:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52802 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbZEVOJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:09:33 -0400
Date: Fri, 22 May 2009 16:09:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Peter Feuerer <peter@piie.net>, petkovbb@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090522140930.GA26580@elf.ucw.cz>
References: <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090519203015.GA1362@ucw.cz> <9ea470500905220450s2367f8a1uc2b19a9466ea8509@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500905220450s2367f8a1uc2b19a9466ea8509@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> The idea of not starting the module in kernel mode was from Matthew. And
> >> he stated that it could harm the hardware when software controls the fan
> >> instead of the BIOS. It may also be possible, that the warranty gets
> >
> > Well... hw is usually designed to protect itself.
> 
> It seems like the fan in the aspire one's is used for cooling the
> surrounding devices too and while the thermal envelope of the CPU is
> much wider, the peripherals are much more susceptible to temperatures
> outside of their allowed operating range. That's why currently the
> driver lets the BIOS control the fan since its settings are most
> conservative.

Yep, I don't disagree. But I strongly suspect that if you force the
fan off and overheat the machine, it will shut down in hardware before
doing any damage.

> > Kernels crash, too, just like userspace does. It would still make
> > sense to allow userspace to increase fan speed.
> 
> Well, if the kernel is dead, userspace has already died
> too. 

Yep.

> the module can still be toggled on/off from sysfs. Actually, empirically
> measured, there seem to be three states of the fan: off, on and on-max
> where you can hear it rotating at max RPM. The kernel module can handle
> those completely if you know the respective ACPI EC commands and there's
> no need for userspace daemon, IMHO.

It would be still nice to let the userspace lower the trip points for
maximum flexibility. No need for userspace _daemon_.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
