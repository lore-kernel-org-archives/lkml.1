Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYGaOLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYGaOLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYGaOL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:11:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53468 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYGaOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:11:29 -0400
Date: Thu, 31 Jul 2008 16:11:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
Message-ID: <20080731141134.GP23938@one.firstfloor.org>
References: <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> <1199906151.6245.57.camel@cinder.waste.org> <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org> <1217466583.18911.226.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217466583.18911.226.camel@calx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Finally getting rid of SLAB is a much trickier proposition because SLUB
> still loses in a few important corner cases.

The big issue is that we haven't really made much progress on at least
some of these test cases (like the database benchmarks) for quite some
time (and that wasn't for a lack of trying) :-/ Might be a fundamental
problem.

-Andi
