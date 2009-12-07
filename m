Return-Path: <linux-kernel-owner+w=401wt.eu-S935608AbZLGVVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935608AbZLGVVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965023AbZLGVVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:21:34 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:38429 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935595AbZLGVVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:21:34 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc codetoadd support for i.MX5
Date: Mon, 7 Dec 2009 14:21:42 -0700
Message-ID: <DE2504B3A515524BBE6934369EFDC0DA08C2A949@az33exm20.fsl.freescale.net>
In-Reply-To: <20091207200326.GU22533@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc codetoadd support for i.MX5
Thread-Index: Acp3eGNL/Pitoqv4TXG9RH6EFoYVzAACBPig
References: <cover.1259893118.git.amit.kucheria@canonical.com> <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com> <DE2504B3A515524BBE6934369EFDC0DA08C2A56C@az33exm20.fsl.freescale.net> <20091204105908.GJ15126@pengutronix <20091207200326.GU22533@pengutronix.de>
From: "Herring Robert-RA7055" <ra7055@freescale.com>
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Cc: "Sascha Hauer" <s.hauer@pengutronix.de>,
       "Amit Kucheria" <amit.kucheria@canonical.com>,
       "List Linux Kernel" <linux-kernel@vger.kernel.org>,
       <grant.likely@secretlab.ca>, <valentin.longchamp@epfl.ch>,
       <daniel@caiaq.de>, "Nguyen Dinh-R00091" <R00091@freescale.com>,
       <linux-arm-kernel@lists.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

> -----Original Message-----
> From: Robert Schwebel [mailto:r.schwebel@pengutronix.de] 
> Sent: Monday, December 07, 2009 2:03 PM
> To: Herring Robert-RA7055
> Cc: Sascha Hauer; Amit Kucheria; List Linux Kernel; 
> grant.likely@secretlab.ca; valentin.longchamp@epfl.ch; 
> daniel@caiaq.de; Nguyen Dinh-R00091; 
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC][PATCH 03/10] arm: mxc: changes to common 
> plat-mxc codetoadd support for i.MX5
> 
> Rob,
> 
> On Mon, Dec 07, 2009 at 10:17:52AM -0700, Herring Robert-RA7055 wrote:
> > Sorry, my mistake. Sasha is correct that MX27 is v1 and MX25 is v2.
> > 
> > timer_is_v1 is just !timer_is_v2, so really only one is 
> needed. I would
> > define it like this to avoid having to change the timer 
> code again for
> > any new chips:
> > 
> > #define timer_is_v2()   (!(cpu_is_mx1() || cpu_is_mx21() ||
> > cpu_is_mx27()))
> 
> Are you sure that FSL won't invent a v3 timer in the future?

There is no change on my radar, and it has not changed in 5 years. As
long as I'm around it won't change if I can help it. What is coming are
chips with a mixture of i.MX and stmp (Sigmatel) blocks. So there could
be a chip with the stmp timer, but it is completely different anyway.

Regards,
Rob

> 
> rsc
> -- 
> Pengutronix e.K.                           |                  
>            |
> Industrial Linux Solutions                 | 
> http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: 
> +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   
> +49-5121-206917-5555 |
> 
> 
