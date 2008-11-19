Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbYKSQxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbYKSQxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYKSQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:53:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50544 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672AbYKSQxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:53:14 -0500
Date: Wed, 19 Nov 2008 17:53:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc4 suspend issues on Lenovo X200
Message-ID: <20081119165304.GA2009@ucw.cz>
References: <20081114115451.GB4877@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114115451.GB4877@denkbrett.schottelius.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-11-14 12:54:51, Nico -telmich- Schottelius wrote:
> Hello!
> 
> Using 2.6.28-rc4 and *NO* acpi_sleep=s3_bios:
> 
>    - suspend and wakeup on console works (!)
>       -> this is new, before screen was black after wakeup
>    - suspend on x11 works
>      wakeup on x11 freezes, causes automatic reboot
>    - switch away from x11 to console,
>      suspend on console:
>          wakeup -> works
>          switch to x11 -> freeze & reboot

Seems like a X problem to me.... can you try to run X with fbdev
driver?

> It would be nice, if someone could CC me to
> 
>    'nico-linux-lenovox200-suspend at schottelius.org'

Cc yourself, I always do group replies...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
