Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZLGUDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZLGUDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbZLGUDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:03:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58530 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbZLGUDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:03:21 -0500
Date: Mon, 7 Dec 2009 21:03:26 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Herring Robert-RA7055 <ra7055@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Amit Kucheria <amit.kucheria@canonical.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       grant.likely@secretlab.ca, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       Nguyen Dinh-R00091 <R00091@freescale.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc codeto
	add support for i.MX5
Message-ID: <20091207200326.GU22533@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com> <DE2504B3A515524BBE6934369EFDC0DA08C2A56C@az33exm20.fsl.freescale.net> <20091204105908.GJ15126@pengutronix.de> <DE2504B3A515524BBE6934369EFDC0DA08C2A879@az33exm20.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <DE2504B3A515524BBE6934369EFDC0DA08C2A879@az33exm20.fsl.freescale.net>
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
X-Uptime: 21:02:05 up 56 days,  8:51, 10 users,  load average: 0.04, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

On Mon, Dec 07, 2009 at 10:17:52AM -0700, Herring Robert-RA7055 wrote:
> Sorry, my mistake. Sasha is correct that MX27 is v1 and MX25 is v2.
> 
> timer_is_v1 is just !timer_is_v2, so really only one is needed. I would
> define it like this to avoid having to change the timer code again for
> any new chips:
> 
> #define timer_is_v2()   (!(cpu_is_mx1() || cpu_is_mx21() ||
> cpu_is_mx27()))

Are you sure that FSL won't invent a v3 timer in the future?

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
