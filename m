Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYHDXjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYHDXjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbYHDXjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:39:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:51786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbYHDXjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:39:01 -0400
Date: Mon, 4 Aug 2008 16:38:16 -0700
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
Message-ID: <20080804163816.75fa63ba@infradead.org>
In-Reply-To: <20080804223011.GG12464@duo.random>
References: <20080804172728.GJ11476@duo.random>
	<20080804174659.GK11476@duo.random>
	<20080804175730.GL11476@duo.random>
	<1217875739.3589.56.camel@twins>
	<20080804201514.GB12464@duo.random>
	<1217882242.3589.90.camel@twins>
	<20080804210954.GC12464@duo.random>
	<84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com>
	<20080804213018.GD12464@duo.random>
	<20080804144228.5f0c29c3@infradead.org>
	<20080804223011.GG12464@duo.random>
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

On Tue, 5 Aug 2008 00:30:11 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> On Mon, Aug 04, 2008 at 02:42:28PM -0700, Arjan van de Ven wrote:
> > yes lockdep will only complain WHEN you take them in the wrong order
> > 
> > But you claimed you would for sure be in a deadlock at that point
> > which is generally not correct.
> 
> I already said I didn't know about that despite having spent a fair
> amount of time trying to understand why lockdep crashes systems at
> boot about an year ago. I admit I didn't understand much about it and
> reducing its computation time didn't look feasible, perhaps my fault,
> and I'm glad if Peter found a way to make it boot after 1 year.

interesting; lockdep has been working for the last.. 2 1/2 years at
least, and I don't remember seeing bugreports against it from you that
would describe it as totally non-functional.


Oh well.. seems you're rather preoccupied about it; that's ok, you're
entitled to your opinion even if I don't agree with it ;-)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
