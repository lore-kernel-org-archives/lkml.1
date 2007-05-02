Return-Path: <linux-kernel-owner+w=401wt.eu-S2992996AbXEBKG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992996AbXEBKG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXEBKG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:06:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992996AbXEBKG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:06:57 -0400
Date: Wed, 2 May 2007 12:05:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502100545.GA6857@elte.hu>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463854F3.3020403@linux.vnet.ibm.com>
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

> With -v7 I would run the n/n+1 test. Basically on a system with n 
> cpus, I would run n+1 tasks and see how their load is distributed. I 
> usually find that the last two tasks would get stuck on one CPU on the 
> system and would get half the cpu time as their other peers. I think 
> this issue has been around for long even before CFS. But while I was 
> investigating that, I found that with -v8, all the n+1 tasks are stuck 
> on the same cpu.

i believe this problem is specific to powerpc - load is distributed fine 
on i686/x86_64 and your sched_debug shows a cpu_load[0] == 0 on CPU#2 
which is 'impossible'. (I sent a few suggestions off-Cc about how to 
debug this.)

	Ingo
