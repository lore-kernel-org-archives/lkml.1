Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXGFUDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXGFUDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762756AbXGFUD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:03:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763523AbXGFUD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:03:28 -0400
Date: Fri, 6 Jul 2007 22:03:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070706200325.GD8174@one.firstfloor.org>
References: <p73vecx21um.fsf@bingen.suse.de> <5FD5754DDBA0B1499B5A0B4BB5419485015CC88A@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485015CC88A@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 10:50:30AM -0700, Li, Tong N wrote:
> > Also cache misses in this situation tend to be much more than 48
> cycles
> > (even an K8 with integrated memory controller with fastest DIMMs is
> > slower than that)  Mathieu probably measured an L2 miss, not a load
                                                    ^^^^^^^

I meant L2 cache hit of course


> from
> > RAM.
> > Load from RAM can be hundreds of ns in the worst case.
> > 
> 
> The 48 cycles sounds to me like a memory load in an unloaded system, but
> it is quite low. I wonder how it was measured...

I found that memory latency is difficult to measure in modern x86
CPUs because they have very clever prefetchers that can often
outwit benchmarks.

Another trap on P4 is that RDTSC is actually quite slow and synchronizes
the CPU; that can add large measurement errors.

-Andi

