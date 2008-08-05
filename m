Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbYHEB3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbYHEB3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 21:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbYHEBK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 21:10:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:43451 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533AbYHEBK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 21:10:28 -0400
Subject: Re: [PATCH 0/10] introduce generic iommu_num_pages function
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net, paulus@samba.org,
       davem@davemloft.net, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 11:08:44 +1000
Message-Id: <1217898524.24157.124.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 18:04 +0200, Joerg Roedel wrote:
> Hi,
> 
> this series of patches re-introduces the iommu_num_pages function so that it
> can be used by each architecture specific IOMMU implementations. The series
> also changes IOMMU implementations for X86, Alpha, PowerPC and UltraSparc. The
> other implementations are not yet changed because the modifications required
> are not obvious and I can't test them on real hardware.
> 
> The first three patches are to make this series bisectable.  The changes are
> compile-tested on the architectures changed and runtime tested in X86 only. The
> patches apply cleanly to latest linus/master tree.

Had a quick look, it seems allright to me.

Ben.

> Joerg
> 
> git diff --stat linus/master:
> 
>  arch/alpha/kernel/pci_iommu.c      |   17 +++++------------
>  arch/powerpc/kernel/iommu.c        |   23 +++++++----------------
>  arch/sparc64/kernel/iommu.c        |    7 ++++---
>  arch/sparc64/kernel/iommu_common.h |   14 ++------------
>  arch/sparc64/kernel/pci_sun4v.c    |    7 ++++---
>  arch/x86/kernel/amd_iommu.c        |    9 +++++----
>  arch/x86/kernel/pci-calgary_64.c   |   18 ++++--------------
>  arch/x86/kernel/pci-dma.c          |    4 ++--
>  arch/x86/kernel/pci-gart_64.c      |    8 ++++----
>  include/asm-x86/iommu.h            |    2 +-
>  include/linux/iommu-helper.h       |    2 ++
>  lib/iommu-helper.c                 |    9 +++++++++
>  12 files changed, 49 insertions(+), 71 deletions(-)
> 
> 

