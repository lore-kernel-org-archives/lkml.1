Return-Path: <linux-kernel-owner+w=401wt.eu-S1751525Ab0AGJdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0AGJdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833Ab0AGJdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:33:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:39307 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750824Ab0AGJdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:33:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+vkbFMHMCvvZLBAdPdKg6UqOXaTVR8ZiVbd8h+WI
	O6LRump0eFwoCG
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262853903.18931.17.camel@minggr.sh.intel.com>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262659686.22471.121.camel@minggr.sh.intel.com>
	 <1262663058.5748.32.camel@marge.simson.net>
	 <1262673817.9534.37.camel@marge.simson.net>
	 <1262853903.18931.17.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Thu, 07 Jan 2010 10:33:27 +0100
Message-Id: <1262856807.19822.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 16:45 +0800, Lin Ming wrote:
> On Tue, 2010-01-05 at 14:43 +0800, Mike Galbraith wrote:
> > On Tue, 2010-01-05 at 04:44 +0100, Mike Galbraith wrote:
> > > On Tue, 2010-01-05 at 10:48 +0800, Lin Ming wrote:
> > > > On Mon, 2010-01-04 at 17:03 +0800, Lin Ming wrote:
> > > > > commit a03ecf08d7bbdd979d81163ea13d194fe21ad339
> > > > > Author: Lin Ming <ming.m.lin@intel.com>
> > > > > Date:   Mon Jan 4 14:14:50 2010 +0800
> > > > > 
> > > > >     sched: Pass affine target cpu into wake_affine
> > > > >     
> > > > >     Since commit a1f84a3(sched: Check for an idle shared cache in select_task_rq_fair()),
> > > > >     the affine target maybe adjusted to any idle cpu in cache sharing domains
> > > > >     instead of current cpu.
> > > > >     But wake_affine still use current cpu to calculate load which is wrong.
> > > > >     
> > > > >     This patch passes affine cpu into wake_affine.
> > > > >     
> > > > >     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > > 
> > > > Mike,
> > > > 
> > > > Any comment of this patch?
> > > 
> > > The patch definitely looks like the right thing to do, but when I tried
> > > this, it didn't work out well.  Since I can't seem to recall precise
> > > details, I'll let my box either remind me or give it's ack.
> > 
> > Unfortunately, box reminded me.  mysql+oltp peak throughput with
> > nr_clients == nr_cpus
> 
> Did you test with your vmark regression fix patch also applied?

Yeah.  Delta between tested kernels was your patch.

	-Mike

