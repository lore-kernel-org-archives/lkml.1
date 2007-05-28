Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbXE1LI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbXE1LI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXE1LIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:08:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbXE1LIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:08:50 -0400
Date: Mon, 28 May 2007 13:07:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070528110748.GG25331@elte.hu>
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu> <20070525124652.GA24038@elte.hu> <4657128F.7000600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4657128F.7000600@linux.vnet.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Ingo Molnar wrote:
> > i found an accounting bug in this: it didnt sum up threads correctly. 
> > The patch below fixes this. The stime == 0 problem is still there 
> > though.
> > 
> > 	Ingo
> > 
> 
> Thanks! I'll test the code on Monday. I do not understand the 
> sysctl_sched_smoothing functionality, so I do not understand its 
> impact on accounting. I'll take a look more closely

basically sysctl_sched_smoothing is more of a 'experimental features 
flag' kind of thing. I'll remove it soon, you should only need to 
concentrate on the functionality that it enables by default.

	Ingo
