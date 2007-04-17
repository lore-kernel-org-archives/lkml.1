Return-Path: <linux-kernel-owner+w=401wt.eu-S1161382AbXDQWX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161382AbXDQWX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161384AbXDQWX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:23:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4997 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161382AbXDQWX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:23:56 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Apr 2007 15:23:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070417082323.GS8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704171515560.32323@alien.or.mcafeemobile.com>
References: <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au>
 <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de>
 <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de>
 <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de>
 <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417082323.GS8915@holomorphy.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, William Lee Irwin III wrote:

> On Tue, Apr 17, 2007 at 09:01:55AM +0200, Nick Piggin wrote:
> > Latency. Given N tasks in the system, an arbitrary task should get
> > onto the CPU in a bounded amount of time (excluding events like freak
> > IRQ holdoffs and such, obviously -- ie. just considering the context
> > of the scheduler's state machine).
> 
> ISTR Davide Libenzi having a scheduling latency test a number of years
> ago. Resurrecting that and tuning it to the needs of this kind of
> testing sounds relevant here. The test suite Peter Willliams mentioned
> would also help.

That helped me a lot at that time. At every context switch was sampling 
critical scheduler parameters for both entering and exiting task (and 
associated timestamps). Then the data was collected through a 
/dev/idontremember from userspace for analysis. It'd very useful to have 
it those days, to study what really happens under the hook 
(scheduler internal parameters variations and such) when those wierd loads 
make the scheduler unstable.



- Davide


