Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYJBT3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYJBT3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYJBT31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:29:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbYJBT31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:29:27 -0400
Date: Thu, 2 Oct 2008 21:28:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
Message-ID: <20081002192827.GA2950@elte.hu>
References: <20081001223213.078984344@linutronix.de> <1222912413.2995.80.camel@laptop-eth.lan> <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com> <1222962525.2995.100.camel@laptop-eth> <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de> <1222974254.2995.144.camel@laptop-eth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222974254.2995.144.camel@laptop-eth>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> > > Clearly threading irq handlers does have something to do with real 
> > > time, unless this patch isn't actually threading anything ..

Well, that's clearly wrong: threaded IRQ handlers are not tied to 
real-time in any way. Yes, they can be used for RT too but as far as the 
upstream kernel is involved that's at most an afterthought.

and the "unless this patch isn't actually threading anything" bit does 
not parse at all. The patches execute hard-IRQ handlers from special 
kernel threads.

> > Clearly you have neither clue about real time nor about operating 
> > systems in general.
> 
> Here we go again Thomas.. You think you can have a conversation 
> without the insults for once?

what Thomas said was a strong but fair reaction to your obviously 
incorrect statement. What reaction did you expect?

	Ingo
