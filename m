Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYB2JB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYB2JB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYB2JBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:01:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbYB2JBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:01:47 -0500
Date: Fri, 29 Feb 2008 10:00:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Message-ID: <20080229090050.GA19519@elte.hu>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal> <20080228163303.GA6195@redhat.com> <47C73121.2000109@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C73121.2000109@qualcomm.com>
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


* Max Krasnyanskiy <maxk@qualcomm.com> wrote:

>> -allow stop_mahcine_run() to call a function on all cpus. Calling 
>> stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
>>  stop_machine_run() proceeds as normal until the calling cpu has 
>>  invoked 'fn'. Then, we tell all the other cpus to call 'fn'.
>
> Jason, we're actually trying to reduce the usage of the stop_machine 
> in general. [...]

please talk in your own name. Stop-machine is a very elegant tool that 
simplifies a lot of hard things in the kernel and is reasonably fast as 
well. We've just recently added two new usages of it and more are 
planned.

_you_ might be the one who wants to 'reduce the usage of stop_machine' - 
but that means it is _you_ who first has to convert a number of very 
difficult pieces of code to "something else".

	Ingo
