Return-Path: <linux-kernel-owner+w=401wt.eu-S1750927AbXBWFxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927AbXBWFxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 00:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXBWFxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 00:53:00 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50761 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXBWFw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 00:52:59 -0500
Date: Fri, 23 Feb 2007 06:25:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [patch 01/18] bcm43xx: Fix for oops on resume
Message-ID: <20070223052526.GA1889@elf.ucw.cz>
References: <20070221014413.282048309@mini.kroah.org> <20070221014939.GB3684@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221014939.GB3684@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> There is a kernel oops on bcm43xx when resuming due to an overly tight timeout loop.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/wireless/bcm43xx/bcm43xx.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.18.7.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
> +++ linux-2.6.18.7/drivers/net/wireless/bcm43xx/bcm43xx.h
> @@ -21,7 +21,7 @@
>  #define PFX				KBUILD_MODNAME ": "
>  
>  #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
> -#define BCM43xx_IRQWAIT_MAX_RETRIES	50
> +#define BCM43xx_IRQWAIT_MAX_RETRIES	100
>  
>  #define BCM43xx_IO_SIZE			8192

I'm sorry, but this does not look like fixing an oops. It may make it
go away for you, or make it less probable, but it certainly can't fix
it.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
