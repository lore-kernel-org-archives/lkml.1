Return-Path: <linux-kernel-owner+w=401wt.eu-S1763825AbXGPWhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763825AbXGPWhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXGPWh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:37:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbXGPWh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:37:28 -0400
Date: Tue, 17 Jul 2007 00:37:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070716223718.GA494@elte.hu>
References: <20070716.042640.18306462.davem@davemloft.net> <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org> <20070716215117.GA25097@elte.hu> <20070716.150902.55721400.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716.150902.55721400.davem@davemloft.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 16 Jul 2007 23:51:17 +0200
> 
> > i also offered to quickly try any test-version of the fixed patch, so 
> > there's a real and deterministic path towards fixing the patch. The 
> > regression is obvious and triggers all the time.
> 
> For you.

I can certainly keep the revert around in my trees. (although it's a 
complication, i have to take care for it to never leak out into any 
external trees, etc. - but it's not a big issue)

Fundamentally, i trust Olaf to fix this quickly, and i dont want to make 
a too big fuss about this, but in general it's always better to revert 
patches causing known regressions (unless the revert is hugely complex 
and other changes depend on it - but this isnt the case here). I can 
also run whatever test-patches of Olaf, that would instrument/dump 
whatever info is needed to fix this. So Olaf's debugging effort is not 
hindered in any way as far as i can see.

I think if you leaned back and thought it through, and if you applied 
this scenario to a bad scheduler commit from me that broke your box, 
you'd readily agree with me =B-) (which scenario is purely hypothetical, 
my scheduler commits are all 100% perfect of course ;-)

	Ingo
