Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZFPJoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZFPJoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZFPJof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:44:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47710 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZFPJoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:44:34 -0400
Date: Tue, 16 Jun 2009 11:44:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20090616094429.GA32594@elte.hu>
References: <20090615.050449.144947903.davem@davemloft.net> <20090616091538.GA4184@elte.hu> <20090616.021955.243374916.davem@davemloft.net> <20090616093353.GC4184@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616093353.GC4184@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 16 Jun 2009 11:15:38 +0200
> > 
> > >  [<ffffffff810489e6>] __might_sleep+0xf6/0x120
> > >  [<ffffffff81b3921d>] lock_sock_nested+0x3d/0x120
> > >  [<ffffffff81c1a7d2>] x25_destroy_socket+0x22/0x180
> > >  [<ffffffff81c1aa4e>] x25_destroy_timer+0xe/0x10
> > >  [<ffffffff81060619>] run_timer_softirq+0x1d9/0x2e0
> > >  [<ffffffff81060560>] ? run_timer_softirq+0x120/0x2e0
> > 
> > What on your system is openning x25 sockets?  Some stress/torture 
> > program that opens random sockets?
> 
> No, just plain default bootup on (pretty old) Fedora user-space. 
> Nothing fancy and no networking related stress-tests.
> 
> > Or have you gotten into packet radio recently? :-)
> 
> Not intentionally ;-)
> 
> Below is a full bootlog with the config i sent, against vanilla 
> 03347e2. I'll turn off CONFIG_[A]X25 summarily.

With [a]x25 off the warning+crash went away (no surprise there :).
There were no other problems with that config.

	Ingo
