Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbXAYAdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbXAYAdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXAYAdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:33:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48369 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933100AbXAYAdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:33:22 -0500
Date: Thu, 25 Jan 2007 01:32:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like 2.16.19.2
Message-ID: <20070125003242.GA23343@elf.ucw.cz>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan> <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan> <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Is it highmem-related? Can you try it with mem=256M?
> 
> Bad idea, the kernel crashes & burns when I use mem=256, I had to boot 
> 2.6.20-rc5-6 single to get back into my machine, very nasty.  Remember I 
> use an onboard graphics controller that has 128MB of RAM allocated to it 
> and I believe the ICH8 chipset also uses some memory, in any event mem=256 
> causes the machine to lockup before it can even get to the boot/init 
> processes, the two leds on the keyboard were blinking, caps lock and 
> scroll lock and I saw no console at all!

Okay, so try mem=700M or disable CONFIG_HIGHMEM or something.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
