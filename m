Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZCIVhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZCIVhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZCIVgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:36:54 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:40534 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZCIVgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:36:53 -0400
Date: Tue, 10 Mar 2009 03:06:44 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090309213644.GA8103@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090307045120.039324630@linux.vnet.ibm.com> <20090307050747.GL23959@in.ibm.com> <20090307222955.25A7.A69D9226@jp.fujitsu.com> <20090308100929.GA14133@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308100929.GA14133@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 11:09:29AM +0100, Ingo Molnar wrote:
> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi
> > 
> > > This patch adds an ftrace plugin to detect and profile memory access over
> > > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > > addresses.
> > > 
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > > ---
> > >  kernel/trace/Kconfig          |    6 
> > >  kernel/trace/Makefile         |    1 
> > >  kernel/trace/trace.h          |   16 +
> > >  kernel/trace/trace_ksym.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
> > >  kernel/trace/trace_selftest.c |   36 +++
> > >  5 files changed, 507 insertions(+)
> > 
> > Could you please update Documentation/ftrace.txt?
> > I guess many user interesting this patch. :)
> 
> Yeah, it has become a really nice feature this way. As i told it 
> to K.Prasad before: we need this tracer because the data tracer 
> will likely become the most common usecase of this facility. We 
> will get the hw breakpoints facility tested and used.
> 
> And in fact we can go one step further: it would also be nice to 
> wire it up with the ftrace histogram code: so that we can get 
> usage histograms of kernel symbol read/write activities without 
> the overhead of tracing. (The branch tracer already has this.)
> 
> Especially frequently used variables generate a _lot_ of events.
> 
> 	Ingo

I am looking at the histogram infrastructure, its implementation in
branch tracer for getting the same in ksym tracer. Meanwhile I'm thinking
if the patchset can be included in -tip tree for some good amount of
testing and feedback from the community before they make their way into
mainline (2.6.30?).

I will be glad if you can pick the patches to be a part of -tip tree.

Thanks,
K.Prasad

