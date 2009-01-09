Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZAII1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZAII1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 03:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZAII07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 03:26:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:57317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753463AbZAII06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 03:26:58 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+BzTd+bzKBQSaSt+OnZVr1gflyIk/5NLmMhaAn+A
	mIC1OyCFxd8JU7
Date: Fri, 9 Jan 2009 09:27:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v8] i.MX31: dmaengine and framebuffer drivers
In-Reply-To: <20090109081719.GB2020@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0901090922530.4848@axis700.grange>
References: <Pine.LNX.4.64.0901081850280.6387@axis700.grange>
 <20090109081719.GB2020@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009, Sascha Hauer wrote:

> On Thu, Jan 08, 2009 at 07:04:04PM +0100, Guennadi Liakhovetski wrote:
> > Hi,
> > 
> > This is version 8 of dmaengine and framebuffer drivers for i.MX31.
> 
> Does this depend on some other patch? It does not compile:
> 
> drivers/dma/ipu/ipu_idmac.c: In function 'idmac_tx_submit':
> drivers/dma/ipu/ipu_idmac.c:851: error: invalid type argument of '->'
> drivers/dma/ipu/ipu_idmac.c:851: error: invalid type argument of '->'
> drivers/dma/ipu/ipu_idmac.c: In function 'idmac_alloc_chan_resources':
> drivers/dma/ipu/ipu_idmac.c:1490: error: invalid type argument of '->'
> drivers/dma/ipu/ipu_idmac.c:1490: error: invalid type argument of '->'
> drivers/dma/ipu/ipu_idmac.c: In function 'ipu_idmac_init':
> drivers/dma/ipu/ipu_idmac.c:1547: error: 'DMA_PRIVATE' undeclared (first use in this function)
> drivers/dma/ipu/ipu_idmac.c:1547: error: (Each undeclared identifier is reported only once
> drivers/dma/ipu/ipu_idmac.c:1547: error: for each function it appears in.)
> drivers/dma/ipu/ipu_idmac.c:1551: warning: assignment from incompatible pointer type

A quote from the message you're replying to:

> > Changes since version 7: updated to today's Linus git with pulled patches 
> > from async_tx tree (dmaengine)

and later

> > Based on Linus' git commit 9e42d0cf5020aaf217433cad1a224745241d212a
> > plus git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

So, yes, you have to pull that tree, there are a few patches there...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
