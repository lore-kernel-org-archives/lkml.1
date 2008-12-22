Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYLVMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYLVMYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYLVMYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:24:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42580 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYLVMYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:24:42 -0500
Date: Mon, 22 Dec 2008 13:24:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: Brad Campbell <brad@wasp.net.au>,
       Manfred Spraul <manfred@colorfullife.com>,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: BUG() in 2.6.28-rc8-git2 under heavy load
Message-ID: <20081222122433.GA27124@elte.hu>
References: <494F4C50.1070906@wasp.net.au> <19f34abd0812220406i36d5df21ka321e3eb4993c54c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0812220406i36d5df21ka321e3eb4993c54c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Mon, Dec 22, 2008 at 9:14 AM, Brad Campbell <brad@wasp.net.au> wrote:
> > I got a number of BUG()s in my kernel log during a RAID expansion. I did not
> > notice any ill effects, the system recovered well and has been ok since.
> > I've not had the opportunity to reboot as yet, but I thought them worth
> > reporting.
> >
> > I'm really unsure as to the relevant details on this one, so I've attached
> > everything just in case.
> >
> > I'm also seeing *loads* of [158921.049256] eth0: too many iterations (6) in
> > nv_nic_irq.
> 
> This might be related. You may try to change the max_interrupt_work 
> module parameter to something greater, e.g. 
> forcedeth.max_interrupt_work=50 on the kernel command line or "modprobe 
> forcedeth max_interrupt_work=50" in the terminal.

btw., that default limit of 6 is ridiculously low - i see it trigger on 
all forcedeth boxes i have, under benign load situations - all the time. 
Could someone please send a patch to Jeff that raises it to 50 ?

	Ingo
