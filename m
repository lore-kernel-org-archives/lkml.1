Return-Path: <linux-kernel-owner+w=401wt.eu-S934260AbZKXVsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbZKXVsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933841AbZKXVsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:48:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38591 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754AbZKXVsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:48:10 -0500
Date: Tue, 24 Nov 2009 13:48:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
Message-ID: <20091124214814.GK6831@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1259080406.4531.1645.camel@laptop> <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx> <1259095580.4531.1788.camel@laptop> <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop> <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com> <1259097150.4531.1822.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259097150.4531.1822.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:12:30PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-24 at 13:03 -0800, David Rientjes wrote:
> > On Tue, 24 Nov 2009, Peter Zijlstra wrote:
> > 
> > > Merge SLQB and rm mm/sl[ua]b.c include/linux/sl[ua]b.h for .33-rc1
> > > 
> > 
> > slqb still has a 5-10% performance regression compared to slab for 
> > benchmarks such as netperf TCP_RR on machines with high cpu counts, 
> > forcing that type of regression isn't acceptable.
> 
> Having _4_ slab allocators is equally unacceptable.

I completely agree.  We need at least ten.  ;-)

							Thanx, Paul
