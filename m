Return-Path: <linux-kernel-owner+w=401wt.eu-S1422975AbXDXSId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422975AbXDXSId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422984AbXDXSId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:08:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:37420 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422975AbXDXSIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233199878:sNHT165331005"
Date: Tue, 24 Apr 2007 11:06:34 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070424180633.GG5475@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com> <20070420193856.GC2986@holomorphy.com> <Pine.LNX.4.64.0704201243280.21514@schroedinger.engr.sgi.com> <20070420200322.GD2986@holomorphy.com> <20070420201101.GC5475@linux-os.sc.intel.com> <Pine.LNX.4.64.0704241039110.8341@schroedinger.engr.sgi.com> <20070424174226.GE5475@linux-os.sc.intel.com> <Pine.LNX.4.64.0704241045160.8418@schroedinger.engr.sgi.com> <20070424175001.GF5475@linux-os.sc.intel.com> <Pine.LNX.4.64.0704241054270.8592@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704241054270.8592@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 10:55:45AM -0700, Christoph Lameter wrote:
> On Tue, 24 Apr 2007, Siddha, Suresh B wrote:
> > yes, we were planning to move this to a different percpu section, where
> > all the elements in this new section will be cacheline aligned(both
> > at the start, aswell as end)
> 
> I would not call this a per cpu area. It is used by multiple cpus it 
> seems. 

not decided about the name yet. but the area is allocated per cpu and yes,
the data can be referred by other cpus.

> But for 0.5%? on what benchmark? Is is really worth it?

famous database workload :)

I don't think the new section will be added for this 0.5%. This is a straight
fwd optimization, and anyone can plug into this new section in future.

thanks,
suresh
