Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbXBDFq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbXBDFq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 00:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbXBDFq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 00:46:29 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:5266
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752087AbXBDFq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 00:46:28 -0500
Date: Sat, 3 Feb 2007 21:46:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070204054603.GI5647@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070204002338.GB5647@linux.vnet.ibm.com> <Pine.LNX.4.44L0.0702032220560.17500-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0702032220560.17500-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 10:24:04PM -0500, Alan Stern wrote:
> On Sat, 3 Feb 2007, Paul E. McKenney wrote:
> 
> > > And another note: this all assumes that STORE-MB-LOAD works "correctly", yes?
> > > We have other code which relies on that, should not be a problem.
> > 
> > We have been working with Doug Lea of SUNY Oswego, Sebatian Burckhardt of
> > University of Pennsylvania, and Vijay Saraswat of IBM Research towards
> > a "universal memory model" that accommodates all machines.  Currently,
> > it does in fact handle store-mb-load the way we all want, thankfully!
> 
> We should add that many places in the kernel do depend on proper behavior 
> for this data access pattern.  So whatever "universal memory model" we end 
> up with, it had better handle the pattern correctly if Linux is to support 
> it.

Agreed!

> It's interesting to note, however, that this does exclude simple MESI.

Yep!  And also a number of compiler optimizations, as it turns out.  ;-)

There is a tension between nice-to-software memory-barrier properties
on the one hand and easily understood code on the other.  But I guess
that this is true of pretty much any software tool.

							Thanx, Paul
