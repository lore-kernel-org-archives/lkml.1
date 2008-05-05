Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbYEEXs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbYEEXs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYEEXsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:48:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbYEEXsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:48:17 -0400
Date: Tue, 6 May 2008 01:47:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: Preempt-RT patch for 2.6.25
Message-ID: <20080505234743.GA11433@elte.hu>
References: <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com> <1210003265.17132.6.camel@localhost.localdomain> <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com> <1210004376.17132.14.camel@localhost.localdomain> <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com> <1210007084.17132.32.camel@localhost.localdomain> <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com> <1210013938.17132.55.camel@localhost.localdomain> <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de> <1210025532.17132.82.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210025532.17132.82.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> I think dropping ports (temporarily) is perfectly reasonable. There is 
> no reason to hamper forward development just to keep old architecture 
> ports in the tree.

You are missing the point: a lot of people (those who wrote the brunt of 
the -rt tree and who maintained it over the years and who maintain it 
today) think it's not reasonable and have stated it very clearly to you 
that it's a bug. Keeping things alive is not preventing forward 
development.

So please fix this bug in your refactoring of the queue, so that your 
contribution can be utilized/accepted. There's no obligation on 
maintainers to accept buggy contributions. There's no obligation for you 
to fix this bug in your queue either of course - it's up to you whether 
you want to work with the maintainers so that your contribution can be 
accepted.

Since it's code that you regard stale it shouldnt be all that hard to 
fix it up - in general it's much easier to fix a bug than to talk it out 
of existence, even if you disagree with a maintainer about how 
significant a bug is.

This issue is clearly not central to your refactoring (it cannot be, 
it's all about stale code), so by inflexibly insisting on your opinion 
against the (well-explained) opinion of the maintainers you'll just 
waste their time and make it more difficult for them to work with you, 
for no good reason.

	Ingo
