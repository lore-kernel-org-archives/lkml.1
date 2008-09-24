Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYIXOam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYIXOam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYIXOae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:30:34 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:29960 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYIXOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:30:33 -0400
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7PEYI-04-W3K-01
Date: Wed, 24 Sep 2008 16:30:21 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 gart: remove unnecessary initialization
Message-ID: <20080924143021.GW24392@amd.com>
References: <20080924224038N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080924224038N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 24 Sep 2008 14:30:21.0451 (UTC) FILETIME=[132B0DB0:01C91E52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 10:41:10PM +0900, FUJITA Tomonori wrote:
> This is against tip/x86/iommu
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] x86 gart: remove unnecessary initialization in struct dma_mapping_ops
> 
> There is no point to have such initialization in struct dma_mapping_ops.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-gart_64.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 25c94fb..b85a2f9 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -715,12 +715,6 @@ extern int agp_amd64_init(void);
>  static struct dma_mapping_ops gart_dma_ops = {
>  	.map_single			= gart_map_single,
>  	.unmap_single			= gart_unmap_single,
> -	.sync_single_for_cpu		= NULL,
> -	.sync_single_for_device		= NULL,
> -	.sync_single_range_for_cpu	= NULL,
> -	.sync_single_range_for_device	= NULL,
> -	.sync_sg_for_cpu		= NULL,
> -	.sync_sg_for_device		= NULL,
>  	.map_sg				= gart_map_sg,
>  	.unmap_sg			= gart_unmap_sg,
>  	.alloc_coherent			= gart_alloc_coherent,

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

