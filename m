Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbXJCVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbXJCVU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbXJCVUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:20:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:8052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347AbXJCVUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,226,1188802800"; 
   d="scan'208";a="161969545"
Date: Wed, 3 Oct 2007 14:14:53 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, tomof@acm.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm] intel-iommu sg chaining support
Message-ID: <20071003211452.GA14189@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070929125638W.tomof@acm.org> <20071001161256.GA28998@askeshav-devel.jf.intel.com> <20071003141203.fae1edf5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003141203.fae1edf5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 02:12:03PM -0700, Andrew Morton wrote:
> On Mon, 1 Oct 2007 09:12:56 -0700
> "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> > On Sat, Sep 29, 2007 at 05:16:38AM -0700, FUJITA Tomonori wrote:
> > > 
> > >    x86_64 defines ARCH_HAS_SG_CHAIN. So if IOMMU implementations don't
> > >    support sg chaining, we will get data corruption.
> > >    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > 
> > Acked-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > 
> 
> Am I correct in believing that this patch is needed only when the
> chaining patches which are presently in git-block are combined with the
> intel-iommu work which is presently in -mm?
Yes, that is correct. 

-Anil
