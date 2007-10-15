Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbXJOQSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbXJOQSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbXJOQSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:18:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952AbXJOQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:18:23 -0400
Date: Mon, 15 Oct 2007 18:18:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: WARNING: at net/core/dev.c:2161 net_rx_action()
Message-ID: <20071015161816.GA3730@elte.hu>
References: <20071015112430.GA30006@elte.hu> <20071015112705.GA31150@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015112705.GA31150@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> >   WARNING: at net/core/dev.c:2161 net_rx_action()
> >    [<80564db4>] net_rx_action+0xce/0x186
> >    [<8011ba98>] __do_softirq+0x6c/0xcf
> >    [<8011bb2d>] do_softirq+0x32/0x36
> >    [<8011bcae>] irq_exit+0x35/0x40
> >    [<80104fdb>] do_IRQ+0x5c/0x71
> >    [<801048cd>] do_nmi+0x8f/0x238
> >    [<801033a3>] common_interrupt+0x23/0x30
> >    =======================
> > 
> > box is operating fine otherwise. config and bootlog attached. This 
> > warning got introduced by:
> 
> unfortunately the warning seems spurious - i just rebooted the box 
> into the same kernel and the message did not trigger again.

update: i got this warning for a second time now with another config - 
so i guess if someone sent me a fix-patch or debug-patch i would 
eventually trigger it within a day again.

	Ingo
