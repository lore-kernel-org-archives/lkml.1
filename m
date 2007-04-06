Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXDHMBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXDHMBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 08:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXDHMBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 08:01:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4567 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbXDHMBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 08:01:43 -0400
Date: Fri, 6 Apr 2007 12:07:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 28/90] ARM: OMAP: USB peripheral support on H4
Message-ID: <20070406120749.GA3866@ucw.cz>
References: <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <11757100403021-git-send-email-tony@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11757100403021-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> H4 has two peripheral ports, one for "download" and one for OTG.
> The one to use is selected through Kconfig.
> 
> NOTE:  not yet working; I suspect there's a clock still turned off
> or something like that, since neither port responds.

Hmm, it would be nice to merge this with patch that makes it
working... for easier review.

But it is new code, so maybe it can just go in....

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

> +#else
> +	/* S1.10 OFF -- usb "download port"
> +	 * usb0 switched to Mini-B port and isp1105 transceiver;
> +	 * S2.POS3 = ON, S2.POS4 = OFF ... to enable battery charging
> +	 */
> +	.register_dev	= 1,
> +	.pins[0]	= 3,
> +//	.hmc_mode	= 0x14,	/* 0:dev 1:host 2:disable */
> +	.hmc_mode	= 0x00,	/* 0:dev|otg 1:disable 2:disable */

No c++ comments, please... but I somehow suspect this one is fixed
later in series.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
