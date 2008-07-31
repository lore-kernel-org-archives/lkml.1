Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYGaBMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYGaBMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYGaBMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:12:39 -0400
Received: from waste.org ([66.93.16.53]:54508 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYGaBMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:12:38 -0400
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
In-Reply-To: <alpine.LFD.1.10.0807301529190.3277@nehalem.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org>
	 <84144f020807301522r7fb97bfehe0fcdceef10477b9@mail.gmail.com>
	 <alpine.LFD.1.10.0807301529190.3277@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 20:03:44 -0500
Message-Id: <1217466224.18911.224.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-30 at 15:35 -0700, Linus Torvalds wrote:

> [ Of course, google probably mostly returns hits from all those ACM 
>   portals etc. I wonder why google does that - they're almost totally 
>   useless search results. Sad. If somebody knows how to turn those ACM 
>   pay-portals off in google, pls let me know ]

Maybe you, as one of the better known developers in the world, could
write an open letter suggesting that ACM get a clue and open up their
archives. It's ridiculous that physicists, biologists, and historians
should have more and better web resources than the computer scientists.

I propose you start it with "Hey morons".

-- 
Mathematics is the supreme nostalgia of our time.

