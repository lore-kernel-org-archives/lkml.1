Return-Path: <linux-kernel-owner+w=401wt.eu-S1763271AbZLPWx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763271AbZLPWx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763209AbZLPWxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:53:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52960 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763185AbZLPWxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:53:49 -0500
Date: Wed, 16 Dec 2009 23:53:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Arve Hj?nnev?g <arve@android.com>, Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091216225342.GH21102@elf.ucw.cz>
References: <4B1EB57D.6070408@bluewatersys.com>
 <20091208214658.GC4164@elf.ucw.cz>
 <4B1ECEEE.3000209@bluewatersys.com>
 <4B203575.6050407@bluewatersys.com>
 <20091210172458.GJ19454@elf.ucw.cz>
 <4B2150B7.3040207@bluewatersys.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
 <20091211221015.GB24456@elf.ucw.cz>
 <d6200be20912111440k427c5013j2b17191bcbae2d52@mail.gmail.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB10EB@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB10EB@mi8nycmail19.Mi8.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-11 18:12:35, H Hartley Sweeten wrote:
> On Friday, December 11, 2009 3:41 PM, Arve Hj?nnev?g wrote:
> 
> <snip>
> 
> >> Now, it will still need some cleanups -- I'm not sure if gpios are
> >> dream-specific or generic for whole msm.... I kind of assume they
> >> should be generic for msm. Google people, can you help?
> >
> > I'm not exactly sure what you are asking. Gpios in general are not
> > dream specific, the code in board-dream-gpio.c is. Some gpios (e.g.
> > DREAM_4_BALL_UP_0) are used for a dream specific function, but point
> > to a gpio that is generic to the msm architecture.
> 
> <snip>
> 

> >> +++ b/arch/arm/Kconfig
> >> +       select GENERIC_GPIO
> >> +       select ARCH_REQUIRE_GPIOLIB
> >
> > Please do not do this in a board specific change. You have not changed
> > the msm generic gpio support to use gpiolib.
> 
> Where is the msm tree located?  mach-msm in mainline doesn't appea to
> have _any_ gpio support.  

Right.

> Is Pavel's implementation generic enough to
> work with any msm based board?

I think so but I'm not sure; thats what I wanted google to
clarify. Lets keep it dream-specific for now...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
