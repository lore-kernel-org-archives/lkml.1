Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXISCRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXISCRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 22:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXISCRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 22:17:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:55423 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXISCRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 22:17:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,271,1186383600"; 
   d="scan'208";a="313022271"
Date: Tue, 18 Sep 2007 19:17:05 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew.R.wilcox@intel.com
Subject: Re: tbench regression - Why process scheduler has impact on tbench and why small per-cpu slab (SLUB) cache creates the scenario?
Message-ID: <20070919021705.GB20863@linux-os.sc.intel.com>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com> <200709110117.57387.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com> <20070913060432.GB6078@linux-os.sc.intel.com> <Pine.LNX.4.64.0709131055430.8859@schroedinger.engr.sgi.com> <20070914191511.GC6078@linux-os.sc.intel.com> <Pine.LNX.4.64.0709141242200.17369@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709141242200.17369@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 12:51:34PM -0700, Christoph Lameter wrote:
> On Fri, 14 Sep 2007, Siddha, Suresh B wrote:
> > We are trying to get the latest data with 2.6.23-rc4-mm1 with and without
> > slub. Is this good enough?
>
> Good enough. If you are concerned about the page allocator pass through
> then you may want to test the page allocator pass through patchset
> separately. The fastpath of the page allocator is currently not
> competitive if you always free and allocate a single page. If contiguous
> pages are allocated then the pass through is superior.

We are having all sorts of stability issues with -mm kernels, let alone
perf testing :(

For now, we are trying to do slab Vs slub comparisons for the mainline kernels.
Let's see how that goes.

Meanwhile, any chance that you can point us at relevant recent patches/fixes
that are in -mm and perhaps that can be applied to mainline kernel?

thanks,
suresh
