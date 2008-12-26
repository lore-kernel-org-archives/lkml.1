Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYLZInq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYLZInq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYLZInh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:43:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35625 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYLZInh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:43:37 -0500
Date: Fri, 26 Dec 2008 09:43:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_*_CPUTIME_ID)
	goes backward
Message-ID: <20081226084320.GC755@elte.hu>
References: <49547320.9010302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49547320.9010302@jp.fujitsu.com>
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> @@ -321,7 +287,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
>  		cpu->cpu = cputime.utime;
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = cputime.sum_exec_runtime;
>  		break;
>  	}

hm, doesnt this regress precision?

	Ingo
