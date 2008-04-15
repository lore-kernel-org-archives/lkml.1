Return-Path: <linux-kernel-owner+w=401wt.eu-S1765010AbYDOObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765010AbYDOObT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbYDOObK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:31:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687AbYDOObJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:31:09 -0400
Date: Tue, 15 Apr 2008 10:21:29 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415142129.GB28235@redhat.com>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal> <20080415140430.GA6576@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415140430.GA6576@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Apr 15, 2008 at 04:04:30PM +0200, Ingo Molnar wrote:
> [...]
> > I have not seen any counter argument for the in-depth analysis of the 
> > instruction cache impact of the optimized markers I've done. Arguing 
> > that the markers are "bloated" based only on "size kernel/sched.o" 
> > output is a bit misleading.
> 
> uhm, i'm not sure what you mean - how else would you quantify bloat than 
> to look at the size of the affected subsystem?

For example, by measuring how much of that "bloat" is actually
experienced (e.g., in the form of presence in cache or additional time
taken.) when that instrumentation is turned off vs. on.  That should
sound familiar, as this is the sort of data that you outlined (but I
don't recall whether you actually provided numbers/recipes) when
describing the "dyn-ftrace" nop-padding work.

- FChE
