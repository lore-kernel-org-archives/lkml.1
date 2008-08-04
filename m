Return-Path: <linux-kernel-owner+w=401wt.eu-S1768100AbYHDVo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768100AbYHDVo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765483AbYHDVnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:43:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:49018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1771054AbYHDVnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:43:00 -0400
Date: Mon, 4 Aug 2008 14:42:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
 mm_take_all_locks
Message-ID: <20080804144228.5f0c29c3@infradead.org>
In-Reply-To: <20080804213018.GD12464@duo.random>
References: <20080804162657.GI11476@duo.random>
	<1217867935.3589.35.camel@twins>
	<20080804172728.GJ11476@duo.random>
	<20080804174659.GK11476@duo.random>
	<20080804175730.GL11476@duo.random>
	<1217875739.3589.56.camel@twins>
	<20080804201514.GB12464@duo.random>
	<1217882242.3589.90.camel@twins>
	<20080804210954.GC12464@duo.random>
	<84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com>
	<20080804213018.GD12464@duo.random>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 23:30:18 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> On Tue, Aug 05, 2008 at 12:14:48AM +0300, Pekka Enberg wrote:
> > Sometimes it's hard to actually trigger a deadlock condition during
> > development, especially if you're not developing on a big iron
> > machine.
> 
> My understand is that lockdep can't do static analysis of code, it's
> not a checker. It can only evaluate the locks in the order the cpu
> takes them. And if the CPU never takes them in the wrong order because
> only your unlikely to happen slow path takes them in the wrong order

yes lockdep will only complain WHEN you take them in the wrong order

But you claimed you would for sure be in a deadlock at that point which
is generally not correct.

> So now we learn lockdep also lead developers to think if their code
> doesn't generate lockdep errors it will be safe in production, so
> again more damage thanks to lockdep.

this comment totally puzzles me... rather than calling you naive...
where was this said or even implied????




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
