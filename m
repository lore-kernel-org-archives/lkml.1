Return-Path: <linux-kernel-owner+w=401wt.eu-S1761074AbZE0XaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074AbZE0XaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZE0X34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:29:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50727 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbZE0X3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:29:55 -0400
Date: Thu, 28 May 2009 01:26:36 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: David Miller <davem@davemloft.net>
Cc: timur@freescale.com, scottwood@freescale.com, rmk+lkml@arm.linux.org.uk,
       jacmet@sunsite.dk, r.schwebel@pengutronix.de,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, yuan-bo.ye@motorola.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527232636.GO6805@pengutronix.de>
References: <4A1D9A66.5020002@freescale.com> <20090527.132553.40558501.davem@davemloft.net> <4A1DA24D.5000101@freescale.com> <20090527.135500.217447785.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090527.135500.217447785.davem@davemloft.net>
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
X-Uptime: 01:23:48 up 90 days,  9:05,  1 user,  load average: 0.21, 0.08,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:55:00PM -0700, David Miller wrote:
> > I asked what do drivers do when the MAC address is not in the OF
> > tree, and it is not programmed in hardware (any hardware).
>
> They either fail to probe the device or use a random MAC address,
> the later of which is severely frowned upon.

For embedded, having no dedicated eeprom for the MAC address but
defining them from the bootloader's configuration space is the standard
use case.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
