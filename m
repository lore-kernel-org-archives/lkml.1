Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYLJSn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYLJSn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbYLJSmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:42:53 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:59067 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbYLJSmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:42:51 -0500
X-BigFish: VPS-37(zba6iz1432R98dR936eQ1805M936fOzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KBOBYZ-04-CUN-01
Date: Wed, 10 Dec 2008 19:42:40 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Avi Kivity <avi@redhat.com>, mingo@redhat.com, weidong.han@intel.com,
       torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
Message-ID: <20081210184240.GH12816@amd.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com> <20081210141131.GB12816@amd.com> <1228918928.21454.27.camel@macbook.infradead.org> <20081210142525.GC12816@amd.com> <1228933475.23842.70.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1228933475.23842.70.camel@macbook.infradead.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Dec 2008 18:42:40.0595 (UTC) FILETIME=[149BDA30:01C95AF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 06:24:35PM +0000, David Woodhouse wrote:
> On Wed, 2008-12-10 at 15:25 +0100, Joerg Roedel wrote:
> > I already did it on-top of your tree because Han Weidong's patches 1-17
> > were rebased to your tree and my IOMMU-API patches apply on-top of his
> > patches.
> 
> OK, thanks. Looks like you still need this though, as Mike Day pointed
> out:
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 97df47c..a5f6e28 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -204,7 +204,7 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>  }
>  
>  /* devices under the same p2p bridge are owned in one domain */
> -#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 < 0)
> +#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
>  
>  /* domain represents a virtual machine, more than one devices
>   * across iommus may be owned in one domain, e.g. kvm guest.

Ok, I add it, thanks. Who is the author, Mike or you?

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

