Return-Path: <linux-kernel-owner+w=401wt.eu-S1750705AbXBKPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750705AbXBKPtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXBKPtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:49:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44764 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbXBKPtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:49:40 -0500
Message-ID: <45CF3B0F.9080406@garzik.org>
Date: Sun, 11 Feb 2007 10:49:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch] More defines for dma-mapping-broken.h
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> 9ac7849e35f705830f7b016ff272b0ff1f7ff759 causes this on s390.
> Since we don't support DMA extend dma-mapping-broken.h a bit.
> 
> drivers/base/dma-mapping.c: In function `dmam_noncoherent_release':
> drivers/base/dma-mapping.c:32:
> 	warning: implicit declaration of function `dma_free_noncoherent'
> drivers/base/dma-mapping.c: In function `dmam_alloc_noncoherent':
> drivers/base/dma-mapping.c:129:
> 	warning: implicit declaration of function `dma_alloc_noncoherent'
> drivers/base/dma-mapping.c:129:
> 	warning: assignment makes pointer from integer without a cast
> 
> Cc: Tejun Heo <htejun@gmail.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/asm-generic/dma-mapping-broken.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletion(-)

ACK


