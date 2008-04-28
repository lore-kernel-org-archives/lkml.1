Return-Path: <linux-kernel-owner+w=401wt.eu-S936277AbYD1SWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936277AbYD1SWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934939AbYD1SW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:22:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50652 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934868AbYD1SW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:22:27 -0400
Date: Mon, 28 Apr 2008 20:22:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
	sched-devel.git
Message-ID: <20080428182208.GC1685@elte.hu>
References: <20080424150324.802695381@polymtl.ca> <1209238735.6441.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209238735.6441.4.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Subject: sched: de-uglyfy marker impact

>  		rq = task_rq_lock(p, &flags);
> -		trace_mark(kernel_sched_wait_task, "pid %d state %ld",
> -			p->pid, p->state);
> +		trace_kernel_sched_wait(p);

that does look more compact and more maintainable indeed. (and should 
not impact tracers in any way - we still get the very same marker) Does 
this make scheduler markers more acceptable to you? If yes i'll queue 
this up.

	Ingo
