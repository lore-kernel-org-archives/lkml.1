Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbXGPVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbXGPVJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXGPVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:09:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41276 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbXGPVJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:09:32 -0400
Date: Mon, 16 Jul 2007 23:09:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070716210924.GA17807@elte.hu>
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716.042640.18306462.davem@davemloft.net>
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
> Date: Mon, 16 Jul 2007 11:12:36 +0200
> 
> > Applying the revert patch below makes it work again.
> 
> Well, let's figure out why before we revert because it is attempting 
> to fix a legitimate bug.

yeah, no doubt about it, but this fix breaks my box _for sure_, while 
whatever problem the commit fixed, it was not something that ever 
triggered on my boxes =B-)

so ... i can promise to test whatever new version of the patch Olaf 
sends me (the problem is easy to reproduce and easy to test, so i can 
check it all in a heartbeat), so to get things back on track, and to 
value the time i spent on bisecting this, could we please apply the 
revert upstream (temporarily), because Linus' -git tree as of today is 
still broken for me. (and likely broken for others)

	Ingo
