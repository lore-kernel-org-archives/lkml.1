Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZEVK4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZEVK4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZEVK4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:56:25 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:48091
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751584AbZEVK4Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:56:24 -0400
X-BigFish: VPS-21(zzdf9M1432R98dR1805M873fnzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KK1L1G-04-8K7-01
Date: Fri, 22 May 2009 12:56:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH -tip v2 0/5] add common functions for struct dma_map_ops
Message-ID: <20090522105608.GM9835@amd.com>
References: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090522195446L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090522195446L.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 May 2009 10:56:05.0378 (UTC) FILETIME=[E77DFE20:01C9DACB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 07:54:35PM +0900, FUJITA Tomonori wrote:
> On Fri, 15 May 2009 12:55:00 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > We unified x86 and IA64's handling of multiple dma mapping operations
> > (struct dma_map_ops in linux/dma-mapping.h) so we can remove
> > duplication in their arch/include/asm/dma-mapping.h.
> > 
> > This patchset adds include/asm-generic/dma-mapping-common.h that
> > provides some generic dma mapping function definitions for the users
> > of struct dma_map_ops. This enables us to remove about 100 lines. This
> > also enables us to easily add CONFIG_DMA_API_DEBUG support, which only
> > x86 supports for now. The 4th patch adds CONFIG_DMA_API_DEBUG support
> > to IA64 by adding only 8 lines.
> > 
> > This is against tip/master since tip has some changes to
> > arch/x86/include/asm/dma-mapping.h.
> > 
> > The changes since the first version are
> > 
> > - fixed a bug that dma_attrs is not passed properly (thanks to Arnd
> > Bergmann).
> > 
> > - used a new name, dma-mapping-common.h, instead of dma-mapping.h
> > (suggested by Arnd Bergmann).
> > 
> > - added Joerg's Acked-by
> > 
> > =
> >  arch/ia64/Kconfig                        |    1 +
> >  arch/ia64/include/asm/dma-mapping.h      |  110 ++----------------
> >  arch/x86/Kconfig                         |    1 +
> >  arch/x86/include/asm/dma-mapping.h       |  174 +---------------------------
> >  include/asm-generic/dma-mapping-common.h |  190 ++++++++++++++++++++++++++++++
> >  lib/dma-debug.c                          |   82 ++++++++------
> >  6 files changed, 252 insertions(+), 306 deletions(-)
> 
> Ping,
> 
> Any comments?
>

I already acked the patches :)

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

