Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZLTPUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZLTPUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZLTPUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:20:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:47634 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZLTPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:20:13 -0500
Subject: Re: sched: restore sanity
From: Peter Zijlstra <peterz@infradead.org>
To: San Mehat <san@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 16:19:47 +0100
Message-ID: <1261322387.4314.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
> >> Probably, but the rest is just as annoying, pr_* is crap.

> Oh? Out of curiosity whats wrong with it?

That's what should be asked of printk().

And as long as we're not going to depricate printk() -- any attempt
thereof will meet with fierce resistance from yours truly -- its all a
futile exercise at best, and breaking scripts habits and patches at
worst.

I might be strange, but if I want to print something in C I write
print[fk]() and be done with it, there's no reason what so ever to
introduce fancy wankery for this.

We try to stick to ANSI-C as much as possible, we've got
kalloc,kfree,strcmp,strnlen and all the other 'regular' C bits,
deviating from that serves no purpose but seed confusion.

If driver folks feel the need for dumb-ass wrappers because they can't
write printk() then maybe, otoh if they can't do that, then wtf are they
doing writing drivers anyway.

But I feel this has no place in the core kernel at all, esp when its
getting in the way of things without offering a single benefit.



