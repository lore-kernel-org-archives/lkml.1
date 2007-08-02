Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbXHBUL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbXHBUL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbXHBULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:11:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55362 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbXHBULq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:11:46 -0400
Date: Thu, 2 Aug 2007 22:11:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, marcin.slusarz@gmail.com
Subject: Re: [patch] genirq: temporary fix for level-triggered IRQ resend
Message-ID: <20070802201126.GA27000@elte.hu>
References: <1185322771.4175.102.camel@chaos> <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com> <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731155843.GA7033@elte.hu> <46B20E47.6020403@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B20E47.6020403@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gabriel C <nix.or.die@googlemail.com> wrote:

> I get a warning on each boot now with this patch ..
> 
> [   63.686613] WARNING: at kernel/irq/resend.c:70 check_irq_resend()
> [   63.686636]  [<c013c55c>] check_irq_resend+0x8c/0xa0
> [   63.686653]  [<c013c15f>] enable_irq+0xad/0xb3
> [   63.686662]  [<e886481e>] vortex_timer+0x20c/0x3d5 [3c59x]
> [   63.686675]  [<c01164b9>] scheduler_tick+0x154/0x273
> [   63.686685]  [<c012fed1>] getnstimeofday+0x34/0xe3
> [   63.686697]  [<c0121f4a>] run_timer_softirq+0x137/0x197
> [   63.686709]  [<e8864612>] vortex_timer+0x0/0x3d5 [3c59x]
> [   63.686720]  [<c011ed09>] __do_softirq+0x75/0xe1
> [   63.686729]  [<c011edac>] do_softirq+0x37/0x3d
> [   63.686735]  [<c011ef85>] irq_exit+0x7c/0x7e
> [   63.686740]  [<c010e013>] smp_apic_timer_interrupt+0x59/0x84
> [   63.686751]  [<c0103428>] apic_timer_interrupt+0x28/0x30
> [   63.686759]  [<c0101355>] default_idle+0x0/0x3f
> [   63.686767]  [<c0101385>] default_idle+0x30/0x3f
> [   63.686773]  [<c0100c19>] cpu_idle+0x5e/0x8e
> [   63.686779]  [<c03fdc5f>] start_kernel+0x2d7/0x368
> 
> 
> That means ?:)

if your network still works fine then you can ignore it :-)

we are still trying to figure out what happens with ne2k-pci. The 
message will vanish soon.

	Ingo
