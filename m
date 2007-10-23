Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbXJWHO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbXJWHO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXJWHOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:14:50 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3133 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbXJWHOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:14:48 -0400
Date: Tue, 23 Oct 2007 09:13:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linuxppc-dev@ozlabs.org
Subject: Re: powerpc: Fix fallout from sg_page() changes
Message-ID: <20071023071323.GE25962@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <20071023040948.GA19699@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023040948.GA19699@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007, Olof Johansson wrote:
> Fix fallout from 18dabf473e15850c0dbc8ff13ac1e2806d542c15:
> 
> In file included from include/linux/dma-mapping.h:52,
>                  from drivers/base/dma-mapping.c:10:
> include/asm/dma-mapping.h: In function 'dma_map_sg':
> include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h:289: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h:290: error: 'struct scatterlist' has no member named 'page'
> include/asm/dma-mapping.h: In function 'dma_sync_sg_for_cpu':
> include/asm/dma-mapping.h:331: error: 'struct scatterlist' has no member named 'page'
> 
> drivers/scsi/ps3rom.c: In function 'fetch_to_dev_buffer':
> drivers/scsi/ps3rom.c:150: error: 'struct scatterlist' has no member named 'page'

Applied.

-- 
Jens Axboe

