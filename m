Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYIJOx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYIJOx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYIJOxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:53:19 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50341 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYIJOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:53:18 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K6ZIO0-03-CTC-01
Date: Wed, 10 Sep 2008 16:52:49 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080910145249.GB24392@amd.com>
References: <20080910223735O.fujita.tomonori@lab.ntt.co.jp> <20080910135347.GI6329@amd.com> <20080910232446O.fujita.tomonori@lab.ntt.co.jp> <20080910233819T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080910233819T.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Sep 2008 14:52:49.0836 (UTC) FILETIME=[E515C6C0:01C91354]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 11:39:00PM +0900, FUJITA Tomonori wrote:
 
> btw, in tip/x86/iommu, GART's alloc_coherent always does virtual
> mappings to allocate a size-aligned memory (as DMA-mapping.txt
> defines).
> 
> Because someone strongly insisted, I modified GART's alloc_coherent to
> do so but as I said again and again, it's completely meaningless (only
> POWER IOMMU does it and drivers don't depend on such requirement).
> 
> I guess that it would be better to do virtual mappings only when
> necessary as the current mainline does since GART I/O space is
> precious in some systems. But I don't care much. What's your opinion
> (as a AMD developer)?

Very true. My original rewrite did the mapping only when necessary too.
What were the reasons to do the mapping always?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

