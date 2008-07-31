Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYGaQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYGaQDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYGaQDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:03:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36737 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYGaQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:03:15 -0400
Date: Thu, 31 Jul 2008 18:03:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de, matthew@wil.cx
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
Message-ID: <20080731160320.GQ23938@one.firstfloor.org>
References: <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org> <1217466583.18911.226.camel@calx> <20080731141134.GP23938@one.firstfloor.org> <4891D979.6090802@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4891D979.6090802@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 10:25:45AM -0500, Christoph Lameter wrote:
> Andi Kleen wrote:
> >> Finally getting rid of SLAB is a much trickier proposition because SLUB
> >> still loses in a few important corner cases.
> > 
> > The big issue is that we haven't really made much progress on at least
> > some of these test cases (like the database benchmarks) for quite some
> > time (and that wasn't for a lack of trying) :-/ Might be a fundamental
> > problem.
> 
> It would be good to have more of these benchmark regressions than just TPC which requires a database setup etc etc. Preferably something that is easily runnable by everyone.

AFAIK willy had a small test case for at least one of them.

-Andi
