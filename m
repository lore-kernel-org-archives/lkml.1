Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbXBRUCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbXBRUCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXBRUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:02:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:60098 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbXBRUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:02:38 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <m17iug9dv6.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <20070216195256.GE2572@flint.arm.linux.org.uk>
	 <1171665426.5644.99.camel@localhost.localdomain>
	 <200702170237.42910.arnd@arndb.de>
	 <1171684847.5644.108.camel@localhost.localdomain>
	 <m1tzxlb1b0.fsf@ebiederm.dsl.xmission.com>
	 <1171746949.5644.137.camel@localhost.localdomain>
	 <m17iug9dv6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 07:01:52 +1100
Message-Id: <1171828912.5644.170.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Except for the what appears to be instability of the irq numbers on
> simpler configurations I don't have a problem with it.

I agree that's a bit annoying and I beleive it can be fixed. In
additionm I'd like to look into exposing the domain/HW number -> virq
mapping somewhere in sysfs maybe.

> Until we find a solution for the user space side of things we seem to
> need the unsigned int irq number for user space.  Now I don't want
> people mapping back and forth which is why I don't intend to provide a
> reverse function.

Ok.

> But of course there will be a for_each_irq in the genirq layer so if
> people really want to they will be able to go from the linux irq to 
> an irq_desc.  But we don't have to export that generically (except
> possibly something for the isa irqs).

Ok.

Ben.


