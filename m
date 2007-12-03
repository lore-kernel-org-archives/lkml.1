Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbXLCN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbXLCN5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXLCN5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:57:08 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39706 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882AbXLCN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:57:07 -0500
Date: Mon, 3 Dec 2007 14:57:00 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: acme@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
Message-ID: <20071203135700.GR15974@stusta.de>
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp> <20071202134841.GI15974@stusta.de> <200712030634.CBJ18798.OVFQJSFFOHMtLO@I-love.SAKURA.ne.jp> <20071202214629.GA15034@ghostprotocols.net> <200712032041.ABB90643.SOFVQFtMHFLOOJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712032041.ABB90643.SOFVQFtMHFLOOJ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 08:41:44PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Arnaldo Carvalho de Melo wrote:
> > > But I think ksize() should be available to kernel modules as well as kmalloc() etc.
> > Why do you think so? You have to justify that with some valid use.
> Is there an alternative function?

The question is not whether there's an alternative function.

The kernel does not waste memory for all users by providing a fixed API 
for external modules, the purpose of the kernel is to provide everything 
required for what is shipped with the kernel.

Simply send the patch adding the exports when you submit your module for 
inclusion in the kernel.

> If not, it sounds to me that this is a regression.

That sounds strange considering that slab and slob AFAIR never exported 
this symbol and only slub in 2.6.22 and 2.6.23 exports it.

> We couldn't know how much memory was allocated by kmalloc() in 2.4 era, and we can know it 2.6 era.
> But are we going back to 2.4 era for out-of-tree kernel modules?

The interesting fact is that there are zero in-kernel modules using it.

> Thanks.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

