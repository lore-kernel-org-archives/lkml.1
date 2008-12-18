Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYLRWP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYLRWP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYLRWPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:15:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:57495 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYLRWPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:15:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,245,1228118400"; 
   d="scan'208";a="415697666"
Date: Thu, 18 Dec 2008 14:15:13 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/7] x86 PAT: Add follow_pfnmp_pte routine to help tracking pfnmap pages - v3
Message-ID: <20081218221512.GB3331@linux-os.sc.intel.com>
References: <20081218194126.963894000@intel.com> <20081218194617.247280000@intel.com> <20081218213112.GE10681@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218213112.GE10681@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 01:31:12PM -0800, Nick Piggin wrote:
> On Thu, Dec 18, 2008 at 11:41:28AM -0800, venkatesh.pallipadi@intel.com wrote:
> > Add a generic interface to follow pfn in a pfnmap vma range. This is used by
> > one of the subsequent x86 PAT related patch to keep track of memory types
> > for vma regions across vma copy and free.
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Can you please reuse follow_phys for this? (preferably use the same API
> even if it requires some modification, otherwise if not possible, then
> at least can you implement a common core for both APIs).
> 

Yes. Hadn't noticed the presence of follow_phys before. Will send a patch to
handle this.

Thanks,
Venki
