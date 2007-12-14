Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbXLNXQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbXLNXQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXLNXQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:16:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756AbXLNXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:16:34 -0500
Date: Fri, 14 Dec 2007 15:15:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: caglar@pardus.org.tr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/dma/ioat_dma.c: inlining failed
Message-Id: <20071214151532.f79ec86e.akpm@linux-foundation.org>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C03A18730@orsmsx418.amr.corp.intel.com>
References: <200712142144.47310.caglar@pardus.org.tr>
	<BAE9DCEF64577A439B3A37F36F9B691C03A18730@orsmsx418.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 11:53:28 -0800
"Nelson, Shannon" <shannon.nelson@intel.com> wrote:

> >-----Original Message-----
> >From: S.__a__lar Onur [mailto:caglar@pardus.org.tr] 
> >Sent: Friday, December 14, 2007 11:45 AM
> >To: linux-kernel@vger.kernel.org
> >Cc: Nelson, Shannon
> >Subject: [PATCH] drivers/dma/ioat_dma.c: inlining failed
> >
> >Hi;
> >
> >After commit 7bb67c14fd3778504fb77da30ce11582336dfced, Linus's 
> >git tree gaves following compiliation error with gcc-3.4.6. 
> >Following patch solves this issue for me;
> >
> >
> >[...]
> >  CC [M]  drivers/dma/ioat.o
> >  CC [M]  drivers/dma/ioat_dma.o
> >drivers/dma/ioat_dma.c: In function `ioat1_tx_submit':
> >drivers/dma/ioat_dma.c:177: sorry, unimplemented: inlining 
> >failed in call to '__ioat1_dma_memcpy_issue_pending': function 
> >body not available
> >drivers/dma/ioat_dma.c:268: sorry, unimplemented: called from here
> >make[2]: *** [drivers/dma/ioat_dma.o] Hata 1
> >make[1]: *** [drivers/dma] Hata 2
> >make: *** [drivers] Hata 2
> >
> >Signed-off-by: S.__a__lar Onur <caglar@pardus.org.tr>
> [...]
> 
> Yep.  I posted a similar patch with a couple more tweaks after a month ago after Andrew's comments, which hasn't yet moved from -mm to Linus' tree.  See http://lkml.org/lkml/2007/11/16/336
> 

Nobody told me that it fixed anything serious so I had it scheduled for
2.6.25.  I'll move it up.
