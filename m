Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZFRSRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZFRSRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZFRSQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:16:57 -0400
Received: from sous-sol.org ([216.99.217.87]:42655 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZFRSQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:16:57 -0400
Date: Thu, 18 Jun 2009 11:13:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "'Allen Kay'" <allen.m.kay@intel.com>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Message-ID: <20090618181335.GB19771@sequoia.sous-sol.org>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090513231351.GA22386@linux-os.sc.intel.com> <1242314271.3393.11.camel@macbook.infradead.org> <20090514175944.GA5168@linux-os.sc.intel.com> <20090618180514.GA24082@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618180514.GA24082@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fenghua Yu (fenghua.yu@intel.com) wrote:
> IOMMU Identity Mapping Support: iommu_identity_mapping definition
> 
> Identity mapping for IOMMU defines a single domain to 1:1 map all pci devices
> to all usable memory.
> 
> This will reduces map/unmap overhead in DMA API's and improve IOMMU performance.
> On 10Gb network cards, Netperf shows no performance degradation compared to
> non-IOMMU performance.
> 
> This method may lose some of DMA remapping benefits like isolation.
> 
> The first patch defines iommu_identity_mapping varialbe which controls the
> identity mapping code and is 0 by default.

The only real difference between "pt" and "identity" is hardware support.
We should have a single value we don't have to tell users to do different
things depending on their hardware (they won't even know what they have)
to achieve the same result.

thanks,
-chris
