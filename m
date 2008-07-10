Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbYGJSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbYGJSIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbYGJSHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:07:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35783 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760566AbYGJSHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:07:17 -0400
Date: Thu, 10 Jul 2008 20:06:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Message-ID: <20080710180620.GA30844@elte.hu>
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <200807101725.36175.nickpiggin@yahoo.com.au> <20080710110213.GA6688@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807101020270.11076@woody.linux-foundation.org> <20080710173459.GA11648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710173459.GA11648@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> cool! :)
> 
> (hm, could anyone please resend Nick's original mail? The original one 
> is not in my lkml folder nor on lkml.org - only the quoted one.)

ok, got the mail now now:

| | Annoyed this wasn't a crazy obscure error in the algorithm I could 
| | fix :) [...]

Paul recently ran a formal proof against all sorts of RCU details (and 
found and fixed a few obscure races that way that no-one ever 
triggered), so i'd be quite surprised if we found anything in the core 
algorithm :-)

| | [...] I spent all day debugging it and had to make a special test 
| | case (rcutorture didn't seem to trigger it), and a big RCU state 
| | logging infrastructure to log millions of RCU state transitions and 
| | events. Oh well.

nice debugging!

Acked-by: Ingo Molnar <mingo@elte.hu>

i'm wondering why rcutorture didnt trigger it. I do run !HOTPLUG + 
RCU_PREEMPT kernels and never saw this. Nor did Paul. That aspect is 
weird.

	Ingo
