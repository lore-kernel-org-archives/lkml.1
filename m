Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZLWIoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZLWIoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZLWIoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:44:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:54602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZLWIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:44:21 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mi@jasper.es
In-Reply-To: <c76f371a0912230017n7d3f5c89h849aa23efa6f75e5@mail.gmail.com>
References: <20091221091754.GG4489@kernel.dk>
	 <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>
	 <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
	 <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>
	 <1261504042.4937.59.camel@laptop> <20091222180703.GI10314@basil.fritz.box>
	 <c76f371a0912230017n7d3f5c89h849aa23efa6f75e5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 09:43:32 +0100
Message-ID: <1261557812.4937.118.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 09:17 +0100, Stijn Devriendt wrote:
> On Tue, Dec 22, 2009 at 7:07 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > One reason I liked a more dynamic frame work for this is that it
> > has the potential to be exposed to user space and allow automatic
> > work partitioning there based on available cores.  User space
> > has a lot more CPU consumption than the kernel.
> >
> Basically, this is exactly what I was trying to solve with my
> sched_wait_block patch. It was broken in all ways, but the ultimate
> goal was to have concurrency managed workqueues (to nick the term)
> in userspace and have a way out when I/O hits the workqueue.

Don't we have the problem of wakeup concurrency here?

Forking on blocking is only half the problem (and imho the easy half).

