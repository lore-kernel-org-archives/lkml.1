Return-Path: <linux-kernel-owner+w=401wt.eu-S1765230AbYHDV5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765230AbYHDV5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764818AbYHDV5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:57:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42834
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757489AbYHDV5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:57:16 -0400
Date: Mon, 04 Aug 2008 14:57:13 -0700 (PDT)
Message-Id: <20080804.145713.12569716.davem@davemloft.net>
To: andrea@qumranet.com
Cc: a.p.zijlstra@chello.nl, davej@redhat.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
 mm_take_all_locks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080804210954.GC12464@duo.random>
References: <20080804201514.GB12464@duo.random>
	<1217882242.3589.90.camel@twins>
	<20080804210954.GC12464@duo.random>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <andrea@qumranet.com>
Date: Mon, 4 Aug 2008 23:09:54 +0200

> On Mon, Aug 04, 2008 at 10:37:22PM +0200, Peter Zijlstra wrote:
> > You're so wrong it not even funny. It reports about deadlocks before
> > they happen. All it needs is to observe a lock order violation and it
> 
> Now tell me how it helps to report them... It tells me the system has
> crashed and where, it's not like I couldn't figure it out by myself
> but just noticing nothing works and all cpus are spinning in some
> spinlock slow path and pressing sysrq+t/p.

It tells you about deadlock scenerios that you haven't even encoutered
yet.  It shows bugs for parallel code path sequences that have not
even occurred yet.

But I think you're beyond the point of being able to see why lockdep
is valuable.  So why don't we just move on.
