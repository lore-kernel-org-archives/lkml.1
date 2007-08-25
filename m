Return-Path: <linux-kernel-owner+w=401wt.eu-S1764376AbXHYQxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764376AbXHYQxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 12:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbXHYQxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 12:53:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47583 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbXHYQxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 12:53:35 -0400
Date: Sat, 25 Aug 2007 09:52:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, travis@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/6] x86: Reduce Memory Usage and Inter-Node message
 traffic (v2)
Message-Id: <20070825095223.c6822bd2.randy.dunlap@oracle.com>
In-Reply-To: <20070825092434.GE16227@bingen.suse.de>
References: <20070824222654.687510000@sgi.com>
	<20070825005017.GC1894@linux-os.sc.intel.com>
	<20070825092434.GE16227@bingen.suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 11:24:35 +0200 Andi Kleen wrote:

> On Fri, Aug 24, 2007 at 05:50:18PM -0700, Siddha, Suresh B wrote:
> > On Fri, Aug 24, 2007 at 03:26:54PM -0700, travis@sgi.com wrote:
> > > Previous Intro:
> > 
> > Thanks for doing this.
> > 
> > > In x86_64 and i386 architectures most arrays that are sized
> > > using NR_CPUS lay in local memory on node 0.  Not only will most
> > > (99%?) of the systems not use all the slots in these arrays,
> > > particularly when NR_CPUS is increased to accommodate future
> > > very high cpu count systems, but a number of cache lines are
> > > passed unnecessarily on the system bus when these arrays are
> > > referenced by cpus on other nodes.
> > 
> > Can we move cpuinfo_x86 also to per cpu area? Though critical run
> 
> I worry how much impact that would be? boot_cpu_data is quite 
> widely used. 
> 
> > Wonder if this confusion is the reason for git commit f3fa8ebc
> 
> What git commit (full id) ? 

Looks like it's
commit f3fa8ebc25129bb69929e20b0c84049c39029d8d
Author: Rohit Seth <rohitseth@google.com>
Date:   Mon Jun 26 13:58:17 2006 +0200

    [PATCH] x86_64: moving phys_proc_id and cpu_core_id to cpuinfo_x86

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
