Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYJUHed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYJUHed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYJUHeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:34:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYJUHeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:34:15 -0400
Date: Tue, 21 Oct 2008 09:33:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: Bug in "genirq: record trigger type"
Message-ID: <20081021073350.GA22351@elte.hu>
References: <200810202205.m9KM5une024759@hera.kernel.org> <1224570730.7654.242.camel@pasglop> <86802c440810210022i75d3c081r8fc979386cdda9ce@mail.gmail.com> <20081021072857.GA333@elte.hu> <1224574343.7654.244.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224574343.7654.244.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2008-10-21 at 09:28 +0200, Ingo Molnar wrote:
> 
> > From: Chris Friesen <cfriesen@nortel.com>
> > Date: Mon, 20 Oct 2008 12:41:58 -0600
> > Subject: [PATCH] genirq: fix set_irq_type() when recording trigger type
> > 
> > In set_irq_type() we want to pass the type rather than the current
> > interrupt state.
> > 
> > Signed-off-by: Chris Friesen <cfriesen@nortel.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

thx, added your ack to the commit as well.

	Ingo
