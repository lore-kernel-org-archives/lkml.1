Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZFTPrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZFTPrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 11:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZFTPre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 11:47:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41586 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZFTPrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 11:47:33 -0400
Date: Sat, 20 Jun 2009 17:47:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [bug] __nf_ct_refresh_acct(): WARNING: at lib/list_debug.c:30
	__list_add+0x7d/0xad()
Message-ID: <20090620154716.GA12901@elte.hu>
References: <20090616.034752.226811527.davem@davemloft.net> <20090616105304.GA3579@elte.hu> <20090616122415.GA16630@elte.hu> <20090617092152.GA17449@elte.hu> <4A38C2F3.3000009@gmail.com> <20090617110803.GA10175@elte.hu> <20090618052356.GA18722@elte.hu> <4A39D778.9020607@cosmosbay.com> <4A3A0D45.8090806@trash.net> <4A3A5599.4080906@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3A5599.4080906@trash.net>
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


* Patrick McHardy <kaber@trash.net> wrote:

> Ingo, could you please try whether this patch (combined with the 
> last one) makes any difference? Enabling CONFIG_NETFILTER_DEBUG 
> could also help.

Mind pushing it upstream, and i'll keep things monitored over the 
week following when it hits upstream?

The reason is, the crash ratio is worse than 1:1000, it took a day 
and a 1000 tests to trigger that one. I havent seen it after that.

So it's going to be a very slow observation and you shouldnt 
serialize on me - giving you a 'it works' positive result will take 
10,000 random bootp tests or so - that's a week or longer. (it can 
take a long time to hit that especially in the merge window when 
there's a lot of various test failures that cause hickups in the 
test stream.)

( Mailing me an upstream sha1 when all fixes in this area have hit 
  upstream would certainly be welcome - i can use that as a 'no 
  crashes expected in that area from that point on' flag day. )

Thanks,

	Ingo
