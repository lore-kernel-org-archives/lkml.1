Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYGYH0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYGYH0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYGYH0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:26:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYGYH0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:26:46 -0400
Date: Fri, 25 Jul 2008 09:26:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ecashin@coraid.com,
       axboe@suse.de, mike.miller@hp.com, a.p.zijlstra@chello.nl, rjw@sisk.pl
Subject: Re: [lockdep warning] AOE / networking: aoenet_xmit:
	noop_qdisc.q.lock, INFO: inconsistent lock state at 0000000000000370
Message-ID: <20080725072624.GA21824@elte.hu>
References: <20080721.134608.75595942.davem@davemloft.net> <20080725062009.GA6476@elte.hu> <20080724.232521.193699299.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724.232521.193699299.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 25 Jul 2008 08:20:09 +0200
> 
> > not sure whether it got reported already, but -tip testing triggered 
> > this new ATA over Ethernet lockdep warning on latest -git:
> 
> Thanks for the report, does this fix it?

i've tested it and the warning went away - thanks David!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
