Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbYDOQbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbYDOQbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYDOQbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:31:18 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:47986 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbYDOQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:31:17 -0400
Date: Tue, 15 Apr 2008 21:43:49 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415161349.GA7444@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <20080415125009.GA5573@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415125009.GA5573@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 04:50:09PM +0400, Alexey Dobriyan wrote:
> On Tue, Apr 15, 2008 at 08:32:34AM -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:
> > > 
> > > > +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> > > > +			"abs_time:%p bitset:%d",
> > > > +			uaddr, fshared, val, abs_time, bitset);
> > > 
> > > This is some seriuosly ugly looking gunk, why would we want stuff like
> > > that scattered across the code?
> > > 
> > 
> > I don't really see how it differs so much from printks, which kernel
> > developers are already familiar with.
> 
> They aren't in every -E codepath, nor they are at the start
> and at the end of every important function (like system call).
> 
> Such printks are usually inserted during debugging when you don't care
> about ugliness and these patches will eventually make kernel looks like
> being permanently debugged one.
>
Wondering how useful would printks be when debugging large systems (say
analysing futex contention on a 32-way CPU system)....also to mention
the inability to do a binary dump of the interested data structures.

--K.Prasad
 
