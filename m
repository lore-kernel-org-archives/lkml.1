Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYLDIvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYLDIvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYLDIvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:51:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:48082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751268AbYLDIvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:51:13 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19wJcRgdZBwcQr/BVu2nSApZDCe0870moGzzomPP6
	orXUJYMTFSFBlv
Date: Thu, 4 Dec 2008 09:51:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dmaengine redux continued
In-Reply-To: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
Message-ID: <Pine.LNX.4.64.0812040937010.5079@axis700.grange>
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, 3 Dec 2008, Dan Williams wrote:

> Here are a few more dmaengine cleanups targeted for 2.6.29.  The bulk of the
> change is fixing the dmaengine sysfs implementation.
> 
> It has been pushed out to the 'upstream' tree of async_tx.git[1] and will move
> to -next shortly.
> 
> ---
> 
> Dan Williams (4):
>       dmaengine: bump initcall level to arch_initcall
>       dmaengine: advertise all channels on a device to dma_filter_fn
>       dmaengine: use idr for registering dma device numbers
>       dmaengine: add a release for dma class devices and dependent infrastructure

What about the last hunk from the patch at

http://marc.info/?l=linux-arm-kernel&m=122607472721145&w=2

? Can we add this tx_free pointer? Would you like me to submit it as a 
separate patch? I'd like to be able to reuse tx-descriptors in clients, so 
I then have to explicitly release them in the dmaengine device 
(controller) driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
