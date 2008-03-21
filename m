Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYCUONz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYCUONz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYCUONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:13:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35285 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYCUONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:13:47 -0400
Date: Fri, 21 Mar 2008 07:13:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scalability requirements for sysv ipc
Message-ID: <20080321141339.GB9618@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net> <47E3B924.3000304@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3B924.3000304@colorfullife.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 02:33:24PM +0100, Manfred Spraul wrote:
> Nadia Derbey wrote:
> >Manfred Spraul wrote:
> >>
> >>A microbenchmark on a single-cpu system doesn't help much (except 
> >>that 2.6.25 is around factor 2 slower for sysv msg ping-pong between 
> >>two tasks compared to the numbers I remember from older kernels....)
> >
> >If I remember well, at that time I had used ctxbench and I wrote some 
> >other small scripts.
> >And the results I had were around 2 or 3% slowdown, but I have to 
> >confirm that by checking in my archives.
> >
> Do you have access to multi-core systems? The "best case" for the rcu 
> code would be
> - 8 or 16 cores
> - one instance of ctxbench running on each core, bound to that core.
> 
> I'd expect a significant slowdown. The big question is if it matters.

I could give it a spin -- though I would need to be pointed to the
patch and the test.

						Thanx, Paul
