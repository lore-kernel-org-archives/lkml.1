Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbZKMXJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbZKMXJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbZKMXJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:09:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35078 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453AbZKMXJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:09:18 -0500
Date: Sat, 14 Nov 2009 00:09:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, spencer@bluehost.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com,
       sgruszka@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix granularity of task_u/stime()
Message-ID: <20091113230910.GA11280@elte.hu>
References: <4AFB9029.9000208@jp.fujitsu.com>
 <tip-761b1d26df542fd5eb348837351e4d2f3bc7bffe@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-761b1d26df542fd5eb348837351e4d2f3bc7bffe@git.kernel.org>
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


* tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Commit-ID:  761b1d26df542fd5eb348837351e4d2f3bc7bffe
> Gitweb:     http://git.kernel.org/tip/761b1d26df542fd5eb348837351e4d2f3bc7bffe
> Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> AuthorDate: Thu, 12 Nov 2009 13:33:45 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 12 Nov 2009 15:23:47 +0100
> 
> sched: Fix granularity of task_u/stime()
> 
> Originally task_s/utime() were designed to return clock_t but
> later changed to return cputime_t by following commit:

i think this one causes this new warning in -tip:

 include/trace/events/timer.h:279: warning: format '%lu' 
 expects type 'long unsigned int', but argument 4 has type 'cputime_t'

	Ingo
