Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZLTP22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZLTP22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZLTP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:28:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:43491 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754130AbZLTP21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:28:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19W3DJlDJpWzIhGVgbEPfi9T7gOP2yANRtNW2Ycy2
	aFfOclOwy/yiPK
Subject: Re: sched: restore sanity
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: San Mehat <san@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1261322387.4314.22.camel@laptop>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	 <1261322387.4314.22.camel@laptop>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 16:28:23 +0100
Message-Id: <1261322903.6105.64.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 16:19 +0100, Peter Zijlstra wrote:
> On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
> > >> Probably, but the rest is just as annoying, pr_* is crap.
> 
> > Oh? Out of curiosity whats wrong with it?
> 
> That's what should be asked of printk().
> 
> And as long as we're not going to depricate printk() -- any attempt
> thereof will meet with fierce resistance from yours truly -- its all a
> futile exercise at best, and breaking scripts habits and patches at
> worst.
> 
> I might be strange, but if I want to print something in C I write
> print[fk]() and be done with it, there's no reason what so ever to
> introduce fancy wankery for this.
> 
> We try to stick to ANSI-C as much as possible, we've got
> kalloc,kfree,strcmp,strnlen and all the other 'regular' C bits,
> deviating from that serves no purpose but seed confusion.
> 
> If driver folks feel the need for dumb-ass wrappers because they can't
> write printk() then maybe, otoh if they can't do that, then wtf are they
> doing writing drivers anyway.
> 
> But I feel this has no place in the core kernel at all, esp when its
> getting in the way of things without offering a single benefit.

FWIW, I agree.

You can have my printk when you pry it from my cold dead fingers ;-)

	-Mike

