Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYEIH74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYEIH74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 03:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYEIH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 03:59:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:37930 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751916AbYEIH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 03:59:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ttgB1D4ttRjbLcMXv32LgStpxJkLVcr0GtWwdNO
	dWYX77E6Ynim0h
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1210319417.13978.207.camel@twins>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net>
	 <1210237267.3453.143.camel@ymzhang>
	 <1210238114.11887.3.camel@marge.simson.net>
	 <1210238622.13978.193.camel@twins>  <1210295779.3453.155.camel@ymzhang>
	 <1210315870.13978.204.camel@twins>
	 <1210318362.15296.4.camel@marge.simson.net>
	 <1210319417.13978.207.camel@twins>
Content-Type: text/plain
Date: Fri, 09 May 2008 09:59:43 +0200
Message-Id: <1210319983.5250.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-09 at 09:50 +0200, Peter Zijlstra wrote:
> On Fri, 2008-05-09 at 09:32 +0200, Mike Galbraith wrote:
> > On Fri, 2008-05-09 at 08:51 +0200, Peter Zijlstra wrote:
> > > > > > -rc1.  Do you have the fix below applied?
> > > > > 
> > > > > Oooh - good catch, that seems to be a post -rc1 merge.
> > > > > 
> > > > > Yes this is required.
> > > 
> > > > With below patch+previous_fix_weight_calc, the result is improved, but is still
> > > > about 10% worse than the one of pure 2.6.26-rc1.
> > > > Number of threads: 16
> > > >     read/write requests:                 6104336 (50867.11 per sec.)
> > > > 
> > > 
> > > So puzzling - could you try -git + fix_weight_calc, as I think that is
> > > what Mike tested and proved good on his Quad.
> > 
> > If he still has group scheduling enabled, my box agrees that there's a
> > regression.  I got mysql running, and tested with group scheduling both
> > enabled and disabled, results attached.  (for some reason, I can only
> > test up to 64 threads with mysql though)
> 
> Hm, ok. Does the patch at hand improve or regress the group config for
> you?

Oh, you want me to revert it and retest group?

	-Mike

