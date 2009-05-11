Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZEKPHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZEKPHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbZEKPHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:07:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbZEKPHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:07:31 -0400
Date: Mon, 11 May 2009 17:07:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, balajirrao@gmail.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090511150709.GA23787@elte.hu>
References: <20090509191430.3AD5.A69D9226@jp.fujitsu.com> <tip-50fbed3bb72cbe38a665512771a91a96d028de46@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-50fbed3bb72cbe38a665512771a91a96d028de46@git.kernel.org>
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


* tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Commit-ID:  50fbed3bb72cbe38a665512771a91a96d028de46
> Gitweb:     http://git.kernel.org/tip/50fbed3bb72cbe38a665512771a91a96d028de46
> Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> AuthorDate: Sat, 9 May 2009 19:14:58 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 11 May 2009 14:32:57 +0200
> 
> sched: cpuacct: Use bigger percpu counter batch values for stats counters

-tip testing found a build failure with this patch:

kernel/sched.c:9278: error: ‘percpu_counter_batch’ undeclared (first use in this function)
kernel/sched.c:9278: error: (Each undeclared identifier is reported only once
kernel/sched.c:9278: error: for each function it appears in.)

	Ingo
