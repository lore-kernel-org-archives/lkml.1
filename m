Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZHNVPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZHNVPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZHNVPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:15:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43228 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbZHNVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:15:46 -0400
Date: Fri, 14 Aug 2009 23:15:00 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Zan Lynx <zlynx@acm.org>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090814211500.GC31727@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <4A85AAC4.7050505@acm.org> <20090814185731.GN13320@pengutronix.de> <63386a3d0908141401t6050f39ey8d85213aeccf748a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <63386a3d0908141401t6050f39ey8d85213aeccf748a@mail.gmail.com>
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
X-Uptime: 23:13:33 up 9 days,  8:32,  3 users,  load average: 0.08, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 11:01:58PM +0200, Linus Walleij wrote:
> >> > That's factor 70 away from the 110 ms boot time Tim has talked about
> >> > some days ago (and he measured on an ARM cpu which had almost half
> >> > the speed of this one), and I'm wondering what we can do to improve
> >> > the boot time.
> >>
> >> 2.4s in uncompression? That seems like an obvious target for
> >> improvement.
> >
> > Indeed, we'll check that.
> 
> We got rid of uncompression on a flash-based system vastly improving
> boot time. The reason is that compressed kernels are faster only when
> the throughput to the persistent storage is lower than the decompression
> throughput, and on typical embedded systems with DMA the throughput to
> memory outperforms the CPU-based decompression.
> 
> Of course it depends on a lot of stuff like performance of flash controller,
> kernel storage filesystem performance, DMA controller performance,
> cache architecture etc so it's individual per-system.

We have also done that on NOR based systems, but I'm not sure if it will
work out for NAND as well.

Thanks,

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
