Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZAIIRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZAIIRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 03:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZAIIRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 03:17:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46553 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZAIIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 03:17:31 -0500
Date: Fri, 9 Jan 2009 09:17:19 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v8] i.MX31: dmaengine and framebuffer drivers
Message-ID: <20090109081719.GB2020@pengutronix.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0901081850280.6387@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901081850280.6387@axis700.grange>
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
X-Uptime: 09:10:05 up 26 days, 12:37, 17 users,  load average: 5.73, 2.63,
	1.35
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 07:04:04PM +0100, Guennadi Liakhovetski wrote:
> Hi,
> 
> This is version 8 of dmaengine and framebuffer drivers for i.MX31.

Does this depend on some other patch? It does not compile:

drivers/dma/ipu/ipu_idmac.c: In function 'idmac_tx_submit':
drivers/dma/ipu/ipu_idmac.c:851: error: invalid type argument of '->'
drivers/dma/ipu/ipu_idmac.c:851: error: invalid type argument of '->'
drivers/dma/ipu/ipu_idmac.c: In function 'idmac_alloc_chan_resources':
drivers/dma/ipu/ipu_idmac.c:1490: error: invalid type argument of '->'
drivers/dma/ipu/ipu_idmac.c:1490: error: invalid type argument of '->'
drivers/dma/ipu/ipu_idmac.c: In function 'ipu_idmac_init':
drivers/dma/ipu/ipu_idmac.c:1547: error: 'DMA_PRIVATE' undeclared (first use in this function)
drivers/dma/ipu/ipu_idmac.c:1547: error: (Each undeclared identifier is reported only once
drivers/dma/ipu/ipu_idmac.c:1547: error: for each function it appears in.)
drivers/dma/ipu/ipu_idmac.c:1551: warning: assignment from incompatible pointer type


Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
