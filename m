Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0BVE73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 23:59:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:47365 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754673Ab0BVE71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 23:59:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WPucMsO4WdtQu+Sr9VJrxRNXqSP/MaWP/htMAA0
	nSXEiLudxjrIUN
Subject: Re: [Bug #15192] netperf ~50% regression with 2.6.33-rc1, bisect
 to 1b9508f
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       venkatesh.pallipadi@intel.com, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <1266652377.3464.6.camel@minggr.sh.intel.com>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.Z-B.V7hZLB@chimera>
	 <1265011447.6220.15.camel@marge.simson.net>
	 <1266652377.3464.6.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Mon, 22 Feb 2010 05:59:22 +0100
Message-Id: <1266814762.6072.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 15:52 +0800, Lin Ming wrote:
> On Mon, 2010-02-01 at 16:04 +0800, Mike Galbraith wrote:
> > On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > 
> > Yes, it should remain open.  We're currently waiting for some data from
> > Lin Ming.  The regression itself isn't making much sense.. a kernel with
> > NEWIDLE disabled should show the same performance, but does not.  
> 
> (sorry for late response, I'm just back from vacation)
> 
> We finally located this to a bug in mwait based C-state entry.
> Venki's patch has fixed it.
> http://patchwork.kernel.org/patch/78544/
> 
> Venki, this is the original report,
> http://marc.info/?l=linux-kernel&m=126441481427331&w=4

Excellent, mystery solved.  (adds acpi)

	-Mike

