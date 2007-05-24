Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbXEXVAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbXEXVAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXEXVAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:00:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38885 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXEXVAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:00:44 -0400
Date: Thu, 24 May 2007 22:59:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070524205934.GA19672@elte.hu>
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu> <4655CA84.5060103@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4655CA84.5060103@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > nice! I've merged your patch and it built/booted fine so it should show 
> > up in -v15. This should also play well with Andi's sched_clock() 
> > enhancements in -mm, slated for .23.
> >   
> 
> BTW, does CFS treat sched_clock as a per-cpu clock, or will it compare 
> time values of sched_clock()s called on different CPUs?

it treats it as a per-cpu clock.

	Ingo
