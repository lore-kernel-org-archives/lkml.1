Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYAFM5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYAFM5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYAFM5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:57:36 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2308 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYAFM5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:57:35 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/dma/ioat_dma.c: inlining failed
Date: Sun, 6 Jan 2008 13:57:23 +0100
User-Agent: KMail/1.9.7
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, caglar@pardus.org.tr,
       linux-kernel@vger.kernel.org
References: <200712142144.47310.caglar@pardus.org.tr> <BAE9DCEF64577A439B3A37F36F9B691C03A18730@orsmsx418.amr.corp.intel.com> <20071214151532.f79ec86e.akpm@linux-foundation.org>
In-Reply-To: <20071214151532.f79ec86e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061357.24834.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > >After commit 7bb67c14fd3778504fb77da30ce11582336dfced, Linus's 
> > >git tree gaves following compiliation error with gcc-3.4.6. 
> > >Following patch solves this issue for me;
> > >
> > >
> > >[...]
> > >  CC [M]  drivers/dma/ioat.o
> > >  CC [M]  drivers/dma/ioat_dma.o
> > >drivers/dma/ioat_dma.c: In function `ioat1_tx_submit':
> > >drivers/dma/ioat_dma.c:177: sorry, unimplemented: inlining 
> > >failed in call to '__ioat1_dma_memcpy_issue_pending': function 
> > >body not available
> > >drivers/dma/ioat_dma.c:268: sorry, unimplemented: called from here
> > >make[2]: *** [drivers/dma/ioat_dma.o] Hata 1
> > >make[1]: *** [drivers/dma] Hata 2
> > >make: *** [drivers] Hata 2
> > >
> > >Signed-off-by: S.__a__lar Onur <caglar@pardus.org.tr>
> > [...]
> > 
> > Yep.  I posted a similar patch with a couple more tweaks after a month ago after Andrew's comments, which hasn't yet moved from -mm to Linus' tree.  See http://lkml.org/lkml/2007/11/16/336
> > 
> 
> Nobody told me that it fixed anything serious so I had it scheduled for
> 2.6.25.  I'll move it up.

BTW. It's still not there. Latest Linus linux-2.6 git tree with gcc-3.4.6:

  CC [M]  drivers/dma/ioat_dma.o
drivers/dma/ioat_dma.c: In function `ioat1_tx_submit':
drivers/dma/ioat_dma.c:177: sorry, unimplemented: inlining failed in call to '__ioat1_dma_memcpy_issue_pending': function body not available
drivers/dma/ioat_dma.c:268: sorry, unimplemented: called from here
make[2]: *** [drivers/dma/ioat_dma.o] Error 1
make[1]: *** [drivers/dma] Error 2
make: *** [drivers] Error 2

Regards,

	Mariusz
