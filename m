Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbYGQWoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbYGQWoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYGQWoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:44:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbYGQWoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:44:07 -0400
Date: Fri, 18 Jul 2008 00:43:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, rjw@sisk.pl
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080717224338.GA461@elte.hu>
References: <20080717214222.GA29449@elte.hu> <20080717.144504.96425101.davem@davemloft.net> <20080717220600.GA1701@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717220600.GA1701@elte.hu>
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

> Just re-tried it, the bug is reliably repeatable. Will try a bisection 
> run.

hm, but it was not reproducible on the third and fourth attempt :-( I 
tried hard to provoke it by generating artificial parallel network and 
netconsole output - but it didnt want to trigger. Heisenbug ...

Maybe the debug output gives someone an idea about the nature of the 
bug?

	Ingo
