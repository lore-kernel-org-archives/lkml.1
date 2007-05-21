Return-Path: <linux-kernel-owner+w=401wt.eu-S1765797AbXEUKVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797AbXEUKVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762501AbXEUKUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:20:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765666AbXEUKUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:20:49 -0400
Date: Mon, 21 May 2007 12:20:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521102009.GA12196@elte.hu>
References: <20070517174533.GA538@elte.hu> <20070521080351.GA13375@elte.hu> <20070521081201.GB13858@elte.hu> <200705211544.58018.kernel@prachanda.hub>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705211544.58018.kernel@prachanda.hub>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Anant Nitya <kernel@prachanda.info> wrote:

> Tcp:
>     5 connections established

hm, this does not explain the /proc/net/tcp overhead i think - although 
it could be a red herring. Will have a closer look at your new trace. 

if possible please try to generate the automatic softirq trace for 
Thomas, and then a separate trace for the firefox/net-lag thing, using 
trace-it-10sec.c. Btw., for the second trace, could you boot with 
maxcpus=1? That would make the second trace quite a bit more 
straightforward to analyze. You probably need both cpus to trigger the 
softirq problem.

	Ingo
