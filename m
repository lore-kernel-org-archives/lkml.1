Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab0CIGF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:05:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:42055 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751243Ab0CIGFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:05:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18cdFAGaoEcnCv60Ll2BXmSLVJEvN4ekla2Lht1tF
	8bBcK61UR1XA5o
Subject: Re: [patch 2/2] sched: fix select_idle_sibling() logic in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1268087062.2830.285.camel@sbs-t61.sc.intel.com>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <20100305184213.922106492@sbs-t61.sc.intel.com>
	 <1267820755.6384.85.camel@marge.simson.net>
	 <1268087062.2830.285.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Date: Tue, 09 Mar 2010 07:05:49 +0100
Message-Id: <1268114749.6349.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 14:24 -0800, Suresh Siddha wrote:
> On Fri, 2010-03-05 at 12:25 -0800, Mike Galbraith wrote:
> > On Fri, 2010-03-05 at 10:39 -0800, Suresh Siddha wrote:
> > > plain text document attachment (fix_lat_ctx.patch)
> > > Performance improvements with this patch:
> > > "lat_ctx -s 0 2" ~22usec (before-this-patch)	~5usec (after-this-patch)
> > 
> > Hm.  On my Q6600 box, it's nowhere near that.
> 
> My numbers are based on an atom netbook.

Wish I had an atom to play with, hard to even imagine 22 usec lat_ctx,
that's some _serious_ pain.

> > Calling the waking cpu idle in that case is a mistake.  Just because the
> > sync hint was used does not mean there is no gain to be had. 
> 
> Ok. I dropped that part in v2 patches that I just posted.

Yeah, I see mails (ramble ramble) crossed in the night.  I'll take them
out for a spin, see if your box can get fixed up without busting mine :)

	-Mike

