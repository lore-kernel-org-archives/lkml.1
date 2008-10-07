Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbYJGQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbYJGQk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJGQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:40:49 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:48174 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753443AbYJGQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:40:48 -0400
Date: Tue, 7 Oct 2008 22:10:16 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miao Xie <miaox@cn.fujitsu.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [Bug #11207] VolanoMark regression with 2.6.27-rc1
Message-ID: <20081007164016.GB7607@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.S8B.b975IB@wind> <200810080211.42210.nickpiggin@yahoo.com.au> <1223394526.26330.52.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223394526.26330.52.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 05:48:46PM +0200, Peter Zijlstra wrote:
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
> 

This hits only when sched_compat_yield is set. Sadly, the machine which
did reproduce this for me has gone down. Currently I am away from that
machine for another two weeks. I can try giving it a shot again then.

-- 
regards,
Dhaval
