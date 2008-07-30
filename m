Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbYG3WD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbYG3WD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYG3WDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:03:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbYG3WDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:03:49 -0400
Date: Wed, 30 Jul 2008 15:00:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>
Message-ID: <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>  <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>  <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>  <1199314218.4497.109.camel@cinder.waste.org> 
 <20080103085239.GA10813@elte.hu>  <1199378818.8274.25.camel@cinder.waste.org>  <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>  <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI> 
 <1199641910.8215.28.camel@cinder.waste.org>  <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>  <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org>
 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Pekka J Enberg wrote:
> 
> Subject: [PATCH] binalloc: best-fit allocation with binning
> From: Pekka Enberg <penberg@cs.helsinki.fi>

Shoot me now. 

> As suggested by Linus,

I'm happy to hear that the thing worked, but I'm not sure how happy I 
should be about yet _another_ allocator. Will it ever end?

But seriously, it looks simple and small enough, so in that sense there 
doesn't seem to be a problem. But I really don't look forward to another 
one of these, at least not without somebody deciding that yes, we can 
prune one of the old ones as never being better. Hmm?

		Linus
