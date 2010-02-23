Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0BWQbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:31:05 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39299 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752243Ab0BWQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:31:01 -0500
Date: Tue, 23 Feb 2010 17:30:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [RFC,PATCH] Route kbd leds through the generic leds layer
 (Was: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII)
Message-ID: <20100223163052.GF6220@elf.ucw.cz>
References: <20091117115503.GB1657@x200>
 <20091117132358.GJ12736@const.bordeaux.inria.fr>
 <20091119131854.GA1628@x200.localdomain>
 <20091119132828.GA31025@const.bordeaux.inria.fr>
 <20091119133737.GE31025@const.bordeaux.inria.fr>
 <4B055F24.8030307@zytor.com>
 <20091120190730.GB1434@ucw.cz>
 <20091120204612.GA31728@elf.ucw.cz>
 <4B0709D4.6010305@zytor.com>
 <20100221050107.GG6133@const.homenet.telecomitalia.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100221050107.GG6133@const.homenet.telecomitalia.it>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Route keyboard leds through the generic leds layer.
> 
> This permits to reassign keyboard LEDs to something else than keyboard
> "leds" state, and also permits to fix #7063 by using a modifier to
> implement proper CapsLock behavior and have the keyboard caps lock led
> show that caps lock state.

Yes please.

> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Looks good. ACK.

> --- linux-2.6.32-orig/lib/Kconfig.debug	2009-12-03 13:44:04.000000000 +0100
> +++ linux-2.6.32-perso/lib/Kconfig.debug	2010-02-21 04:36:23.000000000 +0100
> @@ -103,7 +103,7 @@
>  
>  config DEBUG_SECTION_MISMATCH
>  	bool "Enable full Section mismatch analysis"
> -	depends on UNDEFINED
> +	#depends on UNDEFINED
>  	# This option is on purpose disabled for now.
>  	# It will be enabled when we are down to a resonable number
>  	# of section mismatch warnings (< 10 for an allyesconfig build)

You probably want to leave this bit.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
