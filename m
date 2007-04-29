Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXD2HbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXD2HbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXD2HbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:31:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbXD2HbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:31:03 -0400
Date: Sun, 29 Apr 2007 09:30:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429073030.GA5253@elte.hu>
References: <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429071627.GC23638@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> > know of any other reports then please let me know!)
> 
> There was Caglar Onur too but he said he will redo all the tests. 
> [...]

well, Caglar said CFSv7 works as well as CFSv6 in his latest tests and 
that he'll redo all the tests to re-verify his original regression 
report :)

> In fact, what I'd like to see in 2.6.22 is something better for 
> everybody and with *no* regression, even if it's not perfect.
>
> I had the feeling that SD matched that goal right now, [...]

curious, which are the reports where in your opinion CFS behaves worse 
than vanilla? There were two audio skipping reports against CFS, the 
most serious one got resolved and i hope the other one has been resolved 
by the same fix as well. (i'm still waiting for feedback on that one)

> [...] except for Mike who has not tested recent versions. [...]

actually, dont discount Mark Lord's test results either. And it might be 
a good idea for Mike to re-test SD 0.46?

	Ingo
