Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXDIVow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXDIVow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXDIVoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:44:23 -0400
Received: from nlpi012.sbcis.sbc.com ([207.115.36.41]:25036 "EHLO
	nlpi012.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966007AbXDIVnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:43:33 -0400
X-ORBL: [67.117.73.34]
Date: Mon, 9 Apr 2007 17:42:59 -0400
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 28/90] ARM: OMAP: USB peripheral support on H4
Message-ID: <20070409214252.GG7818@atomide.com>
References: <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <11757100403021-git-send-email-tony@atomide.com> <20070406120749.GA3866@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406120749.GA3866@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [070408 08:02]:
> Hi!
> 
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > H4 has two peripheral ports, one for "download" and one for OTG.
> > The one to use is selected through Kconfig.
> > 
> > NOTE:  not yet working; I suspect there's a clock still turned off
> > or something like that, since neither port responds.
> 
> Hmm, it would be nice to merge this with patch that makes it
> working... for easier review.

I've merged the later fixes into this patch, please see the reposted
series and renumbered patch:

[PATCH 1/7] ARM: OMAP: USB peripheral support on H4

And it is working now, so I've updated the commit message too.

> But it is new code, so maybe it can just go in....
> 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> > +#else
> > +	/* S1.10 OFF -- usb "download port"
> > +	 * usb0 switched to Mini-B port and isp1105 transceiver;
> > +	 * S2.POS3 = ON, S2.POS4 = OFF ... to enable battery charging
> > +	 */
> > +	.register_dev	= 1,
> > +	.pins[0]	= 3,
> > +//	.hmc_mode	= 0x14,	/* 0:dev 1:host 2:disable */
> > +	.hmc_mode	= 0x00,	/* 0:dev|otg 1:disable 2:disable */
> 
> No c++ comments, please... but I somehow suspect this one is fixed
> later in series.

That was fixed in the later patch too.

Regards,

Tony
