Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbYKRIqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbYKRIqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYKRIqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:46:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36904 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYKRIq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:46:29 -0500
Date: Tue, 18 Nov 2008 09:45:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081118084541.GJ17838@elte.hu>
References: <20081117184951.GA5585@elte.hu> <20081117220828.GB6398@elte.hu> <4921ED16.9050307@cosmosbay.com> <20081117.212352.77940634.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117.212352.77940634.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Mon, 17 Nov 2008 23:15:50 +0100
> 
> > Yes, I mentioned it later. But apparently you dont read my mails, 
> > so I will just stop now.
> 
> Yeah I was going to mention this too :-/

I spent hours profiling the networking code, and no, i didnt read all 
the incoming emails in parallel - i read them after that.

I have established it beyond reasonable doubt that the scheduler is 
doing the right thing with the config i've posted. Your "wakeup is two 
orders of magnitude more expensive" claim, which got me to measure and 
profile this stuff, is not reproducible here and this regression 
should not be listed as a scheduler regression.

	Ingo
