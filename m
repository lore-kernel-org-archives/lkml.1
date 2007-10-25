Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbXJYIyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbXJYIyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXJYIyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:54:24 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19828 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbXJYIyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:54:23 -0400
Date: Thu, 25 Oct 2007 10:52:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc1] fix sg_phys to use dma_addr_t
Message-ID: <20071025085239.GH5053@kernel.dk>
References: <Pine.LNX.4.64.0710241957240.4733@blonde.wat.veritas.com> <20071024192949.346687ed@laptopd505.fenrus.org> <200710251051.30429.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710251051.30429.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25 2007, Rolf Eike Beer wrote:
> Am Donnerstag, 25. Oktober 2007 schrieb Arjan van de Ven:
> > > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > > ---
> > > Whether this is a complete patch, suitable for all architectures,
> > > I'm not sure: it builds, boots and runs correctly on the x86_32 box
> > > in question, but you'll be a lot wiser than me about using dma_addr_t
> > > for everyone.  (Seems a bit of a shame to include <asm/types.h> here,
> > > when I think all arches already get to include it one way or another,
> > > typically via asm/scatterlist.h; but I guess it's safest to repeat
> > > it.)
> >
> > there is a problem with this... sg_phys doesn't return an actual *dma*
> > address.... at least not an address you can give to the device.
> > Using dma_addr_t is thus a bit misleading.....
> 
> Ok, then: how do I actually get such an address?

You use the dma mapping api, Documentation/DMA-mapping.txt

-- 
Jens Axboe

