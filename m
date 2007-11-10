Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbXKJL12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbXKJL12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXKJL1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:27:21 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:40136 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbXKJL1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:27:20 -0500
Date: Sat, 10 Nov 2007 12:26:32 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Message-ID: <20071110112632.GQ8087@pengutronix.de>
References: <20071110080629.GA18520@linux-sh.org> <20071110091057.GA10446@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071110091057.GA10446@flint.arm.linux.org.uk>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:14:31 up 221 days,  4:40, 11 users,  load average: 0.24, 0.13, 0.10
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: Re: ARM defconfig bogosity in current git
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 09:10:57AM +0000, Russell King wrote:
> > diff --git a/arm/configs/netx_defconfig b/arm/configs/netx_defconfig
> > new file mode 100644
> > index 0000000..57f32f3
> > --- /dev/null
> > +++ b/arm/configs/netx_defconfig
> > 
> > ...
> > 
> > Isn't there something in Documentation/ about -p1 being a good idea
> > precisely so this sort of silliness is avoided?
> 
> -p1 doesn't avoid this when the patch just contains new files.
> Unfortunately, you have to rely both on people spotting such things
> and whoever's generating the patch doing the right thing.
> 
> There will be times when things slip through though.
> 
> > Currently this breaks tab completion on arch/, which is very much a
> > regression ;-)
> 
> Robert?

Aaargh, that came from a broken script changing the patch from p0 to p1...
Please simply revert that patch, I'll send a new and correct one.

Sorry for the noise.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

