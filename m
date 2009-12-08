Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZLHKYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZLHKYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:24:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZLHKYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:24:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbZLHKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:23:53 -0500
Date: Tue, 8 Dec 2009 11:23:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, Brian Swetland <swetland@google.com>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: dream: glue for mmc controller
Message-ID: <20091208102351.GG12264@elf.ucw.cz>
References: <20091103105319.GA2492@elf.ucw.cz>
 <20091103105737.GE20341@fluff.org.uk>
 <20091108081314.GA16482@elf.ucw.cz>
 <20091108091009.GB20529@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108091009.GB20529@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-11-08 09:10:10, Russell King - ARM Linux wrote:
> On Sun, Nov 08, 2009 at 09:13:14AM +0100, Pavel Machek wrote:
> > > > +#include <asm/io.h>
> > > > +#include <asm/gpio.h>
> > > linux/gpio.h
> > > linux/io.h
> > 
> > I got compile errors when trying to use linux/gpio.h:
> > 
> > arch/arm/mach-msm/board-dream-gpio.c: In function
> > 'dream_gpio_configure':
> > arch/arm/mach-msm/board-dream-gpio.c:109: error: 'GPIOF_OUTPUT_LOW'
> > undeclared (first use in this function)
> 
> This means it's abusing the gpio header files - which are intended for
> the generic GPIO support, but are being used for this platforms private
> non-generic GPIO based stuff.

Ok, will fix.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
