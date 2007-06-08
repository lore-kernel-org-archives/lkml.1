Return-Path: <linux-kernel-owner+w=401wt.eu-S1031271AbXFHS3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031271AbXFHS3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764732AbXFHS3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:29:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:3785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762870AbXFHS3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,400,1175497200"; 
   d="scan'208";a="254837285"
Date: Fri, 8 Jun 2007 11:25:27 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 05/10] IOVA allocation and management routines
Message-ID: <20070608182526.GB24865@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.741931000@askeshav-devel.jf.intel.com> <20070607163417.84f96405.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607163417.84f96405.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:34:17PM -0700, Andrew Morton wrote:
> On Wed, 06 Jun 2007 11:57:03 -0700
> anil.s.keshavamurthy@intel.com wrote:
> 
> > +
> > +#define PAGE_SHIFT_4K		(12)
> > +#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
> > +#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
> > +#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
> 
> hm.  We can't use the architecture's PAGE_SHIFT and friends here?
I will see how I can get rid of this.

-Anil
