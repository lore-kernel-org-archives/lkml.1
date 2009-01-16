Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZAPKKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZAPKKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbZAPKJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:09:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:56770 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758309AbZAPKJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:09:55 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19jdfVIRNpj+W9X3kwvAVczyP65/5BTDjSIMeejJ6
	owCKQLCDH0kE/a
Date: Fri, 16 Jan 2009 11:09:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
In-Reply-To: <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901161106100.4940@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
 <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Dan Williams wrote:

> On Fri, Dec 26, 2008 at 10:11 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi,
> >
> > This is version 6 of dmaengine and framebuffer drivers for i.MX31.
> >
> 
> Tha drivers/dma/ bits look ok to me minus the new warnings:
> 
> drivers/dma/ipu/ipu_irq.c: In function 'ipu_irq_fn':
> drivers/dma/ipu/ipu_irq.c:328: warning: 'irq' may be used
> uninitialized in this function
> drivers/dma/ipu/ipu_irq.c: In function 'ipu_irq_err':
> drivers/dma/ipu/ipu_irq.c:290: warning: 'irq' may be used
> uninitialized in this function
> 
> I can take patches 1 and 2 through the async_tx tree, or if you would
> rather, add my Acked-by to those and take 1-4 through the MXC tree.
> I'll be sending the async_tx pull request for 2.6.29 in the next few
> days.

Ok, let's do it this way: Sascha has acked version 8 of patches 2 and 3. 
And there seems to be no active framebuffer maintainer ATM. So, maybe you 
could take patches 1-3 into your tree, so they are exposed to the public, 
people have easier access to them in case they want to test (I had several 
requests), and you update them in case you change async-tx API again:-) It 
would be good to try and push them in for 2.6.29 - these are new drivers, 
so, might still be possible to convince Andrew / Linus, if not, you could 
keep them in your tree (and in next) until 2.6.30, then we'd add platform 
bindings and the camera driver. What do you think?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
