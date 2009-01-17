Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbZAQG3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbZAQG3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZAQG3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:29:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:41781 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751898AbZAQG3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:29:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/3y2VLw6/34+2nBMfDLEw8VdanP9ey3Ypag5mMPo
	Lq2GucRFU9XfXL
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 07:29:36 +0100
Message-Id: <1232173776.7073.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 20:40 -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2009 21:24:07 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2009-01-14 at 12:15 -0800, Andrew Morton wrote:
> > > On Sun, 11 Jan 2009 15:43:05 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Please pull the latest sched-fixes-for-linus git tree
> > > 
> > > In http://bugzilla.kernel.org/show_bug.cgi?id=12309 the reporters have
> > > identified what appears to be a sched-related performance regression. 
> > > A fairly long-term one - post-2.6.18, perhaps.
> > > 
> > > Testcase code has been added today.  Could someone please take a look
> > > sometime?
> > 
> > There appear to be two different bug reports in there. One about iowait,
> > and one I'm not quite sure what it is about.
> > 
> > The second thing shows some numbers and a test case, but I fail to see
> > what the problem is with it.
> 
> I had no problem seeing the problem: a gigantic performance regression
> in two CPU-scheduler intensive workloads.

I can reproduce a very bad latency hit, investigating.

	-Mike

