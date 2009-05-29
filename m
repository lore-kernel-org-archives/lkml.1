Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZE2HxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZE2HxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZE2HxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:53:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54304 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZE2HxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:53:13 -0400
Date: Fri, 29 May 2009 09:52:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090529075238.GC24565@pengutronix.de>
References: <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <20090527205218.GA5591@sirena.org.uk> <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com> <20090528124307.GN22742@pengutronix.de> <alpine.LFD.2.00.0905281457170.3397@localhost.localdomain> <20090528150409.GO22742@pengutronix.de> <1243558274.17903.21.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243558274.17903.21.camel@pasglop>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:44:11 up 17 days, 22:08, 10 users,  load average: 0.10, 0.17,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 10:51:14AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2009-05-28 at 17:04 +0200, Sascha Hauer wrote:
> > 
> > We normally hide these subtle details behind a baseboard= kernel
> > parameter. I agree with you that it's far better to have a
> > standardized
> > way to specify this. For my taste the oftree is too bloated for this
> > purpose.
> 
> Define "bloated" ?

I don't mean bloated in terms of kbytes but bloated in terms of complex
code used to parse the device tree. I more than once put information in
the device tree and wondered where this information got lost on the way
to the driver where I wanted to use it. Back on ARM I was very happy to
just have a simple board file which is easier for me to understand and
maintain.
Of course this can be solved with /me learning more about the device
tree, that's why I said 'for my taste'.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
