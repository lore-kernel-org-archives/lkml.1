Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYHMArP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYHMArP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYHMAqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:46:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:50947 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbYHMAqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:46:37 -0400
Date: Wed, 13 Aug 2008 09:45:53 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 2/7] x86: add free_coherent dma_ops callback to GART
 driver
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1218554657-16070-3-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
	<1218554657-16070-3-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080813093935G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 17:24:12 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-gart_64.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 55cc388..18db09b 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c

It would be better to foil this to the first patch, I think. Any
reasonable reason to add alloc_coherent and free_coherent with two
separate patches?

I think that you can remove map_simple in gart (and please don't
forget to remove map_simple in struct dma_mapping_ops. I think only
GART uses that hook).
