Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYIDMT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYIDMT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYIDMTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:19:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:27817 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYIDMTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="612679956"
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <20080904113529.GA25533@elte.hu>
References: <1220518266.9590.22.camel@minggr>
	 <1220519034.8609.206.camel@twins> <1220525579.12161.8.camel@minggr>
	 <20080904110901.GD8668@elte.hu> <1220527806.12161.14.camel@minggr>
	 <20080904113529.GA25533@elte.hu>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 20:19:48 +0800
Message-Id: <1220530788.12161.31.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-09-04 at 13:35 +0200, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > A huge trace result file, see the attachment for more.
> 
> > # tracer: sched_switch
> > #
> > #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> > #              | |      |          |         |
> >           mysqld-3799  [07]   151.411009:   3799:120:R ==>  3807:120:R
> ...
> >         sysbench-3803  [07]   151.417048:   3803:120:R   +  3791:120:S
> 
> ok, this only spans 6 milliseconds, which is probably a bit too light.
> 
> Could you please increase the trace size 32-fold (via 
> /debug/tracing/trace_entries), and send us the (large!) trace file 
> compressed via bzip2 -9, off-list (or via a web link)? [anyone on-list 
> can have a look at the smaller trace file already]

The large trace file also available at below link,
http://myfreefilehosting.com/f/94991018dc_1.31MB 

> 
> Thanks,
> 
> 	Ingo

