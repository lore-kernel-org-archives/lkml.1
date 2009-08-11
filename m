Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZHKMmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZHKMmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZHKMlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:41:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37485 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZHKMlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:41:44 -0400
Date: Tue, 11 Aug 2009 13:38:07 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/5] drivers/mfd: Add Freescale MC13783 driver
Message-ID: <20090811113807.GQ6108@pengutronix.de>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de> <20090811101240.GA7572@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811101240.GA7572@rakim.wolfsonmicro.main>
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
X-Uptime: 13:35:52 up 5 days, 22:54, 41 users,  load average: 0.24, 0.32,
	0.77
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Aug 11, 2009 at 11:12:40AM +0100, Mark Brown wrote:
> On Tue, Aug 11, 2009 at 11:07:43AM +0200, Sascha Hauer wrote:
> 
> > +/*
> > + * Register a client device.  This is non-fatal since there is no need to
> > + * fail the entire device init due to a single platform device failing.
> > + */
> > +static void mc13783_client_dev_register(struct mc13783 *mc13783,
> > +				       const char *name,
> > +				       struct platform_device **pdev)
> 
> Some of this code is looking distinctly familiar :)

Indeed, I added a 'based on' to the header.

> 
> > +#define	SW_SW1A		0
> > +#define	SW_SW1B		1
> 
> This and the other defines following look like they should probably be
> namespaced.

Ok.

Thanks for reviewing. I addressed these comments and the comments you made
to the other patches. I'll delay reposting a bit in case others have
comments aswell.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
