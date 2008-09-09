Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYIIQ11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYIIQ11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYIIQ1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:27:17 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:31542 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbYIIQ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:27:16 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K6XSD1-04-O8Q-01
Date: Tue, 9 Sep 2008 18:27:05 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: Re: [PATCH 0/4] add a helper function, is_buffer_dma_capable()
Message-ID: <20080909162705.GC13536@amd.com>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Sep 2008 16:27:05.0791 (UTC) FILETIME=[E5E244F0:01C91298]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 01:06:45AM +0900, FUJITA Tomonori wrote:
> This patchset adds a trivial helper function, is_buffer_dma_capable()
> and cleans up some IOMMU implementations. This function is to to see
> if a memory region is DMA-capable or not with the arguments, the
> dma_mask (or coherent_dma_mask) of a device and the address and size
> of a memory region. It's useful for IOMMUs that don't do virtual
> mappings at all times.
> 
> The patch for swiotlb is a bug fix (the rest are just
> cleanups). Currently, swiotlb doesn't take account of the size of a
> memory region to see if if the memory region is DMA-capable.

Good idea. This patchset increases the readability of the software
dma-api implementations.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

