Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYAFNEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYAFNEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYAFNEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:04:24 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50216 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYAFNEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:04:24 -0500
Date: Sun, 6 Jan 2008 15:03:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, caglar@pardus.org.tr,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/dma/ioat_dma.c: inlining failed
Message-ID: <20080106130351.GF2082@does.not.exist>
References: <200712142144.47310.caglar@pardus.org.tr> <BAE9DCEF64577A439B3A37F36F9B691C03A18730@orsmsx418.amr.corp.intel.com> <20071214151532.f79ec86e.akpm@linux-foundation.org> <200801061357.24834.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801061357.24834.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:57:23PM +0100, Mariusz Kozlowski wrote:
> Hello,
> 
> > > >After commit 7bb67c14fd3778504fb77da30ce11582336dfced, Linus's 
> > > >git tree gaves following compiliation error with gcc-3.4.6. 
> > > >Following patch solves this issue for me;
> > > >
> > > >
> > > >[...]
> > > >  CC [M]  drivers/dma/ioat.o
> > > >  CC [M]  drivers/dma/ioat_dma.o
> > > >drivers/dma/ioat_dma.c: In function `ioat1_tx_submit':
> > > >drivers/dma/ioat_dma.c:177: sorry, unimplemented: inlining 
> > > >failed in call to '__ioat1_dma_memcpy_issue_pending': function 
> > > >body not available
> > > >drivers/dma/ioat_dma.c:268: sorry, unimplemented: called from here
> > > >make[2]: *** [drivers/dma/ioat_dma.o] Hata 1
> > > >make[1]: *** [drivers/dma] Hata 2
> > > >make: *** [drivers] Hata 2
> > > >
> > > >Signed-off-by: S.__a__lar Onur <caglar@pardus.org.tr>
> > > [...]
> > > 
> > > Yep.  I posted a similar patch with a couple more tweaks after a month ago after Andrew's comments, which hasn't yet moved from -mm to Linus' tree.  See http://lkml.org/lkml/2007/11/16/336
> > > 
> > 
> > Nobody told me that it fixed anything serious so I had it scheduled for
> > 2.6.25.  I'll move it up.
> 
> BTW. It's still not there. Latest Linus linux-2.6 git tree with gcc-3.4.6:
> 
>   CC [M]  drivers/dma/ioat_dma.o
> drivers/dma/ioat_dma.c: In function `ioat1_tx_submit':
> drivers/dma/ioat_dma.c:177: sorry, unimplemented: inlining failed in call to '__ioat1_dma_memcpy_issue_pending': function body not available
> drivers/dma/ioat_dma.c:268: sorry, unimplemented: called from here
> make[2]: *** [drivers/dma/ioat_dma.o] Error 1
> make[1]: *** [drivers/dma] Error 2
> make: *** [drivers] Error 2

The fix is in Linus' tree since 17 Dec 2007, and the line numbers in 
your error messages also don't make sense in the current tree.

Is there any problem with your local copy of the tree?

> Regards,
> 
> 	Mariusz

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

