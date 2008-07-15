Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYGOFv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYGOFv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYGOFvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:51:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:56980 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbYGOFvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:51:20 -0400
Subject: Re: linux-next: Tree for July 14
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Nelson <markn@au1.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hk5fmd6is.wl%tiwai@suse.de>
References: <20080714201249.947400d0.sfr@canb.auug.org.au>
	 <s5hk5fmd6is.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:50:45 +1000
Message-Id: <1216101045.7740.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 02:20 +0200, Takashi Iwai wrote:
> At Mon, 14 Jul 2008 20:12:49 +1000,
> Stephen Rothwell wrote:
> > 
> > Hi all,
> > 
> > With the opening of the merge window, I am hoping my job becomes easier
> > again ... :-)
> 
> The build of next-20080714 failed on ppc32:
> 
>   CC [M]  drivers/infiniband/core/addr.o
> In file included from include/rdma/ib_addr.h:41,
>                  from drivers/infiniband/core/addr.c:44:
> include/rdma/ib_verbs.h: In function 'ib_dma_map_single_attrs':
> include/rdma/ib_verbs.h:1634: error: implicit declaration of function 'dma_map_single_attrs'
> include/rdma/ib_verbs.h: In function 'ib_dma_unmap_single_attrs':
> include/rdma/ib_verbs.h:1643: error: implicit declaration of function 'dma_unmap_single_attrs'
> include/rdma/ib_verbs.h:1644: warning: 'return' with a value, in function returning void
> include/rdma/ib_verbs.h: In function 'ib_dma_map_sg_attrs':
> include/rdma/ib_verbs.h:1721: error: implicit declaration of function 'dma_map_sg_attrs'
> include/rdma/ib_verbs.h: In function 'ib_dma_unmap_sg_attrs':
> include/rdma/ib_verbs.h:1729: error: implicit declaration of function 'dma_unmap_sg_attrs'
> make[3]: *** [drivers/infiniband/core/addr.o] Error 1
> 
> 
> The following patch fixed the build, at least.  Not sure whether it's
> the right fix, though.

Thanks, applied.

Cheers,
Ben.


