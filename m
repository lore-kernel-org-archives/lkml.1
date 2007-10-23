Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXJWXFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXJWXFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXJWXFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:05:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1456 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbXJWXFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:05:13 -0400
Date: Wed, 24 Oct 2007 01:05:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       linux-main <linux-kernel@vger.kernel.org>,
       linuxsh <linuxsh-dev@lists.sourceforge.net>
Subject: Re: [SUPERH] dma-mapping.h structure has no member named page
Message-ID: <20071023230507.GP14671@kernel.dk>
References: <20071023185305.4fd9a084.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023185305.4fd9a084.Kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Kristoffer Ericson wrote:
> Greetings,
> 
> Got this after syncing my tree with linux-2.6.git.
> 
> In file included from include/linux/dma-mapping.h:52,
>                  from include/linux/dmaengine.h:29,
>                  from include/linux/skbuff.h:29,
>                  from include/linux/netlink.h:155,
>                  from include/linux/genetlink.h:4,
>                  from include/net/genetlink.h:4,
>                  from include/linux/taskstats_kern.h:12,
>                  from init/main.c:46:
> include/asm/dma-mapping.h: In function `dma_map_sg':
> include/asm/dma-mapping.h:88: error: structure has no member named `page'
> include/asm/dma-mapping.h:91: error: structure has no member named `page'
> include/asm/dma-mapping.h: In function `dma_sync_sg':
> include/asm/dma-mapping.h:141: error: structure has no member named `page'
> include/asm/dma-mapping.h:144: error: structure has no member named `page'
> make[1]: *** [init/main.o] Error 1
> make: *** [init] Error 2

Pull again, should be ok now.

-- 
Jens Axboe

