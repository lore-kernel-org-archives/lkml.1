Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbZIGIYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbZIGIYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZIGIYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:24:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:60443 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751770AbZIGIYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:24:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19J7/wrz2hJuxB6Yp+VPo8FzkXMq3MLAQ5+sT7hMC
	Q+SO6BYbRi2Uxb
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ani <asinha@zeugmasystems.com>,
       Lucas De Marchi <lucas.de.marchi@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1252310374.7564.6.camel@twins>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net> <1252310374.7564.6.camel@twins>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 10:24:14 +0200
Message-Id: <1252311854.7586.31.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 09:59 +0200, Peter Zijlstra wrote:
> On Sun, 2009-09-06 at 08:32 +0200, Mike Galbraith wrote:
> > On Sat, 2009-09-05 at 19:32 -0700, Ani wrote: 
> > > On Sep 5, 3:50 pm, Lucas De Marchi <lucas.de.mar...@gmail.com> wrote:
> > > >
> > > > Indeed. I've tested this same test program in a single core machine and it
> > > > produces the expected behavior:
> > > >
> > > > rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
> > > > 95%                              4.48%
> > > > 60%                              54.84%
> > > > 50%                              86.03%
> > > > 40%                              OTHER completed first
> > > >
> > > 
> > > Hmm. This does seem to indicate that there is some kind of
> > > relationship with SMP. So I wonder whether there is a way to turn this
> > > 'RT bandwidth accumulation' heuristic off.
> > 
> > No there isn't..
> 
> Actually there is, use cpusets to carve the system into partitions.

Yeah, I stand corrected.  I tend to think in terms of the dirt simplest
configuration only.

	-Mike

