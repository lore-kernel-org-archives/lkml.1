Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYFZH11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYFZH11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYFZH1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:27:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59297 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbYFZH1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:27:18 -0400
Date: Thu, 26 Jun 2008 09:22:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, josh@freedesktop.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: invoke RCU
	readers from irq handlers (timers)
Message-ID: <20080626072239.GB3160@elte.hu>
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com> <20080622200638.GA25328@linux.vnet.ibm.com> <20080625192452.GA12754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625192452.GA12754@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch allows torturing RCU from irq handlers (timers, in this 
> case). A new module parameter irqreader enables such additional 
> torturing, and is enabled by default.  Variants of RCU that do not 
> tolerate readers being called from irq handlers (e.g., SRCU) ignore 
> irqreader.
> 
> (No failures observed, but only short tests thus far.  And no failures 
> observed thus far from about 10 hours of running stock rcutorture in 
> parallel with 170 kernel builds on a two-CPU machine.)

applied to tip/core/rcu - thanks Paul.

> +static int irqreader = 1;	/* RCU readers from irq (timers). */

Good - this means that in bzImage type of tests (built-in rcutorture, no 
modules) this new test variant will be activated by default, right?

	Ingo
