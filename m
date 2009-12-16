Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZLPO0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZLPO0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZLPO0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:26:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbZLPO0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:26:04 -0500
Date: Wed, 16 Dec 2009 15:25:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de
Subject: Re: [tip:sched/urgent] sched: Teach might_sleep() about preemptible
 RCU
Message-ID: <20091216142536.GA18091@elte.hu>
References: <1260830672-7166-1-git-send-regression-fweisbec@gmail.com>
 <tip-ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Commit-ID:  ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd
> Gitweb:     http://git.kernel.org/tip/ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Mon, 14 Dec 2009 23:44:32 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 16 Dec 2009 08:43:16 +0100
> 
> sched: Teach might_sleep() about preemptible RCU

Causes a build failure, so skipped this patch for now:

kernel/sched.c:9661: error: implicit declaration of function 'rcu_preempt_depth'

	Ingo
