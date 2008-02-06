Return-Path: <linux-kernel-owner+w=401wt.eu-S1763138AbYBFMXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138AbYBFMXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762330AbYBFMW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:22:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40293 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762174AbYBFMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:22:57 -0500
Date: Wed, 6 Feb 2008 13:22:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [bug] networking broke, ssh: connect to port 22: Protocol error
Message-ID: <20080206122248.GA5233@elte.hu>
References: <20080206113829.GA14793@elte.hu> <20080206.034243.243568099.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.034243.243568099.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 6 Feb 2008 12:38:29 +0100
> 
> > 
> > randconfig qa on x86.git ran into the following new networking related 
> > problem on latest -git: with the attached .config the testbox comes up 
> > but cannot establish any TCP connections due to -ENOPROTO in 
> > sys_connect().
> 
> Make sure you have the following fix in your tree.
> 
> It might be the cause.
> 
> commit 5d8c0aa9433b09387d9021358baef7939f9b32c4
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Tue Feb 5 03:14:44 2008 -0800

this is already upstream. As i mentioned above i tested latest -git. 
(HEAD 551e4fb2465b8)

So no, it does not fix the problem. The config i sent is a rather 
generic one, it should boot on most whitebox PCs. TCP connections will 
fail immediately, all the time.

(I reverted 5d8c0aa943 as well, that didnt solve the problem either.)

	Ingo
