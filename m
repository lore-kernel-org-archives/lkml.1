Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbYGQWGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbYGQWGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbYGQWGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:06:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbYGQWGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:06:21 -0400
Date: Fri, 18 Jul 2008 00:06:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, rjw@sisk.pl
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080717220600.GA1701@elte.hu>
References: <20080717214222.GA29449@elte.hu> <20080717.144504.96425101.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717.144504.96425101.davem@davemloft.net>
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
> Date: Thu, 17 Jul 2008 23:42:22 +0200
> 
> > 
> > A regression to v2.6.26:
> > 
> > I started getting this skb-head corruption message today, on a T60 
> > laptop with e1000:
> 
> This is very unlikely to be added by us networking folks, no 
> networking merges have happened for the 2.6.27 merge window yet :-)

yeah. That's why i observed:

> > Perhaps SLUB debugging got smarter?

and Cc:-ed SLUB folks. Could be a sleeper cell of bugs gone active ;-) 

Or could be SLUB (-debugging) breakage. Netconsole is pretty reliable on 
this box. (and the bootup continued just fine after this report)

Just re-tried it, the bug is reliably repeatable. Will try a bisection 
run.

	Ingo
