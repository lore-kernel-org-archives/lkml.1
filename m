Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZFBOMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZFBOMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZFBOMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:12:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:49403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZFBOMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:12:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,291,1241420400"; 
   d="scan'208";a="149736550"
Date: Tue, 2 Jun 2009 22:12:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
	in the VM v3
Message-ID: <20090602141222.GD21338@localhost>
References: <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602125713.GG1392@wotan.suse.de> <20090602132538.GK1065@one.firstfloor.org> <20090602132441.GC6262@wotan.suse.de> <20090602134126.GM1065@one.firstfloor.org> <20090602135324.GB21338@localhost> <20090602140639.GQ1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602140639.GQ1065@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 10:06:39PM +0800, Andi Kleen wrote:
> > > Ok you're right. That one is not needed. I will remove it.
> > 
> > No! Please read the comment. In fact __remove_from_page_cache() has a
> > 
> >                 BUG_ON(page_mapped(page));
> > 
> > Or, at least correct that BUG_ON() line together.
> 
> Yes, but we already have them unmapped earlier and the poison check

But you commented "try_to_unmap can fail temporarily due to races."

That's self-contradictory.

> in the page fault handler should prevent remapping.
> 
> So it really should not happen and if it happened we would deserve
> the BUG.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
