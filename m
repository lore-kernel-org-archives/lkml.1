Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXHYJYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXHYJYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXHYJYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:24:40 -0400
Received: from ns.suse.de ([195.135.220.2]:37965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbXHYJYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:24:39 -0400
Date: Sat, 25 Aug 2007 11:24:35 +0200
From: Andi Kleen <ak@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: travis@sgi.com, Andi Kleen <ak@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/6] x86: Reduce Memory Usage and Inter-Node message traffic (v2)
Message-ID: <20070825092434.GE16227@bingen.suse.de>
References: <20070824222654.687510000@sgi.com> <20070825005017.GC1894@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070825005017.GC1894@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:50:18PM -0700, Siddha, Suresh B wrote:
> On Fri, Aug 24, 2007 at 03:26:54PM -0700, travis@sgi.com wrote:
> > Previous Intro:
> 
> Thanks for doing this.
> 
> > In x86_64 and i386 architectures most arrays that are sized
> > using NR_CPUS lay in local memory on node 0.  Not only will most
> > (99%?) of the systems not use all the slots in these arrays,
> > particularly when NR_CPUS is increased to accommodate future
> > very high cpu count systems, but a number of cache lines are
> > passed unnecessarily on the system bus when these arrays are
> > referenced by cpus on other nodes.
> 
> Can we move cpuinfo_x86 also to per cpu area? Though critical run

I worry how much impact that would be? boot_cpu_data is quite 
widely used. 

> Wonder if this confusion is the reason for git commit f3fa8ebc

What git commit (full id) ? 

-Andi
