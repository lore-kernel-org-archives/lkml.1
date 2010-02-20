Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0BTIJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:09:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:1308 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab0BTIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:09:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,507,1262592000"; 
   d="scan'208";a="774379020"
Subject: Re: [Bug #15192] netperf ~50% regression with 2.6.33-rc1, bisect
 to 1b9508f
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       venkatesh.pallipadi@intel.com
In-Reply-To: <1265011447.6220.15.camel@marge.simson.net>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.Z-B.V7hZLB@chimera>
	 <1265011447.6220.15.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 20 Feb 2010 15:52:57 +0800
Message-Id: <1266652377.3464.6.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 16:04 +0800, Mike Galbraith wrote:
> On Mon, 2010-02-01 at 01:22 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Yes, it should remain open.  We're currently waiting for some data from
> Lin Ming.  The regression itself isn't making much sense.. a kernel with
> NEWIDLE disabled should show the same performance, but does not.  

(sorry for late response, I'm just back from vacation)

We finally located this to a bug in mwait based C-state entry.
Venki's patch has fixed it.
http://patchwork.kernel.org/patch/78544/

Venki, this is the original report,
http://marc.info/?l=linux-kernel&m=126441481427331&w=4

Thanks,
Lin Ming

