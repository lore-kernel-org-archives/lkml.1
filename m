Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbXJYCdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbXJYCdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbXJYCdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:33:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49775 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXJYCdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:33:17 -0400
Date: Wed, 24 Oct 2007 19:29:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc1] fix sg_phys to use dma_addr_t
Message-ID: <20071024192949.346687ed@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0710241957240.4733@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0710241957240.4733@blonde.wat.veritas.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Whether this is a complete patch, suitable for all architectures,
> I'm not sure: it builds, boots and runs correctly on the x86_32 box
> in question, but you'll be a lot wiser than me about using dma_addr_t
> for everyone.  (Seems a bit of a shame to include <asm/types.h> here,
> when I think all arches already get to include it one way or another,
> typically via asm/scatterlist.h; but I guess it's safest to repeat
> it.)

there is a problem with this... sg_phys doesn't return an actual *dma*
address.... at least not an address you can give to the device.
Using dma_addr_t is thus a bit misleading.....
