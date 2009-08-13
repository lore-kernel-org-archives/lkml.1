Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZHMGoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZHMGoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZHMGoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:44:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:52263 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZHMGoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:44:20 -0400
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 15:48:42 +1000
Message-Id: <1250142522.3587.110.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 14:08 +0900, FUJITA Tomonori wrote:

> The above swiotlb patchset was merged in -tip so I think that merging
> this patchset via -tip too is the easiest way to handle this patchset.
> 
> The patchset also is available via a git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git powerpc

Hi !

While I generally agree here with the patches, I'm not sure it should be
merged via -tip since it mostly touches arch/powerpc files (and I need
to review it a bit more carefully, hopefully you'll have Ack's hitting
your mailbox later today).

Ben.

> =
>  arch/powerpc/Kconfig                       |    7 +-
>  arch/powerpc/include/asm/device.h          |    7 +-
>  arch/powerpc/include/asm/dma-mapping.h     |  318 +++-------------------------
>  arch/powerpc/include/asm/pci.h             |    4 +-
>  arch/powerpc/include/asm/swiotlb.h         |    8 +-
>  arch/powerpc/kernel/dma-iommu.c            |    2 +-
>  arch/powerpc/kernel/dma-swiotlb.c          |   53 ++---
>  arch/powerpc/kernel/dma.c                  |   13 +-
>  arch/powerpc/kernel/ibmebus.c              |    2 +-
>  arch/powerpc/kernel/pci-common.c           |    6 +-
>  arch/powerpc/kernel/vio.c                  |    2 +-
>  arch/powerpc/platforms/85xx/mpc8536_ds.c   |    3 +-
>  arch/powerpc/platforms/85xx/mpc85xx_ds.c   |    3 +-
>  arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    3 +-
>  arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    3 +-
>  arch/powerpc/platforms/cell/iommu.c        |    2 +-
>  arch/powerpc/platforms/ps3/system-bus.c    |    4 +-
>  include/linux/dma-mapping.h                |    1 +
>  18 files changed, 89 insertions(+), 352 deletions(-)
> 
> 
> 
> 
> 
> 
> 
> 

