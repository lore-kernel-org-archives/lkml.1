Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXEYJTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXEYJTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXEYJTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:19:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbXEYJTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:19:37 -0400
Date: Fri, 25 May 2007 11:19:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525091928.GA3177@elte.hu>
References: <20070525075446.GA20140@elte.hu> <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525090315.GK8094@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > This?    I sent it to you earlier this week:
> 
> Sorry haven't processed those yet.
> 
> Ah. The correct fix here is to clear the tsc flag in boot_cpu_data 
> when the option is set. Will do that.

please indicate that you've picked up my style cleanups, i dont want to 
redo all this a few days/weeks down the line ...

	Ingo
