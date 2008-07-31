Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYGaPly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYGaPly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYGaPlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:41:46 -0400
Received: from waste.org ([66.93.16.53]:60744 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYGaPlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:41:45 -0400
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
In-Reply-To: <4891CBA9.8030203@linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org>
	 <1217466583.18911.226.camel@calx>  <4891CBA9.8030203@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 10:38:58 -0500
Message-Id: <1217518738.3657.28.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-31 at 09:26 -0500, Christoph Lameter wrote:
> Matt Mackall wrote:
> 
> > Finally getting rid of SLAB is a much trickier proposition because SLUB
> > still loses in a few important corner cases.
> 
> Which corner cases? I know about the reports on the TPC issue which I
> guess is a result of the avoidance of queueing in the cold free case.
> It would be good to have a small C program (under an open source
> license) that shows the issue.

That's the one I had in mind, which I have no personal insight into.
 
-- 
Mathematics is the supreme nostalgia of our time.

