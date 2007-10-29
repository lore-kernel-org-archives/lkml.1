Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXJ2Tzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXJ2Tzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXJ2Tz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:55:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:51727 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXJ2Tz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:55:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,343,1188802800"; 
   d="scan'208";a="362796743"
Date: Mon, 29 Oct 2007 12:52:49 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [stable] 2.6.23 boot failures on x86-64.
Message-ID: <20071029195249.GA21225@linux-os.sc.intel.com>
References: <20071029175014.GH7793@redhat.com> <20071029180739.GA17595@kroah.com> <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 11:37:40AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 29 Oct 2007, Greg KH wrote:
> > 
> > I'll be glad to revert it in -stable, if it's also reverted in Linus's
> > tree first :)
> 
> We've had some changes since 2.6.23, and afaik, the 
> "alloc_bootmem_high_node()" code is alreadt effectively dead there. It's 
> only called if CONFIG_SPARSEMEM_VMEMMAP is *not* enabled, and I *think* we 
> enable it by force on x86-64 these days.

If so, we(Nanhai and myself) will take a look at VMEMMAP changes and see if
the bug that the commit 2e1c49db4c640b35df13889b86b9d62215ade4b6 tries to fix is
still open in the latest git.

But I can't explain how 2e1c49db4c640b35df13889b86b9d62215ade4b6 can be
the root cause of Dave's issue in 2.6.23.

thanks,
suresh
