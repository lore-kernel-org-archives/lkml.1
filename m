Return-Path: <linux-kernel-owner+w=401wt.eu-S937271AbYEUUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937271AbYEUUKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937182AbYEUUKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:10:01 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52338 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937125AbYEUUJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:09:59 -0400
Date: Wed, 21 May 2008 23:07:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/advansys.c: fix compile errors
Message-ID: <20080521200743.GK15355@cs181133002.pp.htv.fi>
References: <20080521174152.GF15355@cs181133002.pp.htv.fi> <20080521195332.GV2638@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080521195332.GV2638@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:53:33PM -0600, Matthew Wilcox wrote:
> On Wed, May 21, 2008 at 08:41:52PM +0300, Adrian Bunk wrote:
> > This patch fixes the following compile error on architectures not 
> > providing free_dma():
> 
> Last time this came up, I think the consensus was that those
> architectures should be providing a stub free_dma().

I tried building as many modules as possible on frv, and this was the 
only driver that failed this way.

Another possibility would be to let this driver depend on ISA_DMA_API
(similar to e.g. SCSI_EATA).

Sorry for being lazy, but touching X architectures for fixing the 
compiliation of a driver whose hardware will anyway most likely never
be used on this architecture is IMHO not worth the effort...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

