Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbZE0X5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbZE0X5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbZE0X5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:57:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57772 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021AbZE0X5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:57:08 -0400
Date: Thu, 28 May 2009 01:57:05 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527235704.GQ6805@pengutronix.de>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
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
X-Uptime: 01:50:10 up 90 days,  9:32,  1 user,  load average: 0.00, 0.04,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:22:50PM -0600, Grant Likely wrote:
> 2) Driver binding mechanism:  device tree nodes usually have a
> "compatible" property which is a list of strings. The first string
> describes exactly what the device is (ie. "atmel,24c08") and an
> optional list of other devices which it is register interface
> backwards compatible with.

This is a good example. The "exact" description above doesn't say
anything about some of the details the driver needs to know. Here is the
at24 driver:

http://lxr.linux.no/linux+v2.6.29/include/linux/i2c/at24.h#L18

Where do we get the page size & flags from?

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
