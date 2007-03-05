Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbXCEMZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbXCEMZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbXCEMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:25:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933383AbXCEMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:25:37 -0500
Date: Mon, 5 Mar 2007 13:17:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Message-ID: <20070305121700.GA15895@elte.hu>
References: <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com> <1173027823.24738.156.camel@localhost.localdomain> <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com> <20070305080824.GA20583@elte.hu> <1173090869.24738.198.camel@localhost.localdomain> <20070305103141.GA18404@elte.hu> <6bffcb0e0703050347j5169c672g19996d5c76707123@mail.gmail.com> <20070305115111.GA10675@elte.hu> <6bffcb0e0703050404h5be8d8d4i8e77e90a25150894@mail.gmail.com> <6bffcb0e0703050421l32fa68e8u3791731e4305f5b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703050421l32fa68e8u3791731e4305f5b9@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> I can confirm that without irqpoll everything works fine.

i guess this means that irq10 is screaming, and irqpoll does not find 
any registered irq handler for it?

> irqpoll is recommended as a command line option in 
> Documentation/kdump/kdump.txt

hmmm ...

	Ingo
