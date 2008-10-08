Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbYJHChJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbYJHChJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYJHCg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:36:57 -0400
Received: from mga05.intel.com ([192.55.52.89]:20228 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753822AbYJHCg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:36:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,376,1220252400"; 
   d="scan'208";a="388845061"
Subject: Re: [Bug #11207] VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Miao Xie <miaox@cn.fujitsu.com>
In-Reply-To: <1223394526.26330.52.camel@lappy.programming.kicks-ass.net>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.S8B.b975IB@wind>
	 <200810080211.42210.nickpiggin@yahoo.com.au>
	 <1223394526.26330.52.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 10:36:31 +0800
Message-Id: <1223433391.1685.19.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-10-07 at 17:48 +0200, Peter Zijlstra wrote:
> On Wed, 2008-10-08 at 02:11 +1100, Nick Piggin wrote:
> > On Sunday 05 October 2008 04:28, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.26.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
> > > Subject		: VolanoMark regression with 2.6.27-rc1
> > > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > Date		: 2008-07-31 3:20 (66 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
> > > Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > 		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > > 		  Miao Xie <miaox@cn.fujitsu.com>
> > 
> > Curious: what's happening with this one, handlers? Any progress being made?
> 
> Sadly not much, I can't seem to reproduce :-(
The regression is bigger with more cpu.

> 
> Yanmin, does the wakeup patch I did for oltp help this workload any?
> 
> http://marc.info/?l=linux-kernel&m=122194673932703&w=4
I tested it against 2.6.29-rc9 on 8-core stoakley and 16-core tigerton. volanoMark
chatroom number is default 10.
Basically, comparing with pure 2.6.27-rc9, the patched kernel's result has about 2%
regression. Group scheduling is enabled.

-yanmin


