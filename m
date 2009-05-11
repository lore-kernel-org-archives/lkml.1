Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbZEKVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbZEKVYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZEKVX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:23:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35580 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbZEKVX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:23:57 -0400
Date: Mon, 11 May 2009 23:23:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: trekker.dk@centrum.cz
Cc: tuxonice-devel@lists.tuxonice.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090511212350.GA3397@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz> <20090510053840.GG1363@ucw.cz> <200905112319.8749@centrum.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905112319.8749@centrum.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> >To summarise disadvantages:
> >> >
> >> >- only core has 8000 LoC
> >> >- it does stuff that can be easily done in userspace
> >> >     (and that todays distros _do_ in userspace).
> >> >- it duplicates uswsusp functionality.
> >> >- compared to [u]swsusp, it received little testing
> >> >
> >> 
> >> To summarise advatages - for me tuxonice is the only hibernation method that works.
> >> (Till now I've had 3 machines - no one of them able to resume with in-kernel swsusp.)
> >> 
> >
> >Which kernels you tried, what hw it is? Can you do s2ram?
> 
> Regarding hardware - 
> 
> 1. AMD Athlon 1700+, VIA KT333 chipset based MB, nVidia GeForce 2
> 2. AMD X2 Athlon, AMD690V chipset based MB, nVidia 7600GT
> 3. (current) AMD X4 Phenom II,  AMD780G chipset and nVidia 9600GT 
> (binary driver for video card every time)

Ok, binary drivers may be a problem. Will it work without that? Should
be easy to test with init=/bin/bash.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
