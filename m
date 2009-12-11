Return-Path: <linux-kernel-owner+w=401wt.eu-S1762431AbZLKT61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431AbZLKT61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761837AbZLKT6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:58:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48890 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761771AbZLKT6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:58:21 -0500
Date: Fri, 11 Dec 2009 20:58:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091211195820.GA1980@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
 <4B1EB57D.6070408@bluewatersys.com>
 <20091208214658.GC4164@elf.ucw.cz>
 <4B1ECEEE.3000209@bluewatersys.com>
 <4B203575.6050407@bluewatersys.com>
 <20091210172458.GJ19454@elf.ucw.cz>
 <4B2150B7.3040207@bluewatersys.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> With this you can now just access the dream_gpio_chip data in all
> the member function using the to_dream_gpio_chip() macro.
> 
> I agree with Ryan and think you would be better off in the long
> run to re-code this and use gpiolib.  You might also want to break
> out all the gpio interrupt stuff and submit it as a seperate patch.

Yep, lets ignore the interrupts, I do not need them for led blinking
:-).

And... thanks!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
