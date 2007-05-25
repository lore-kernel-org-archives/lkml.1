Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbXEYID1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbXEYID1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXEYIDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:03:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbXEYIDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:03:08 -0400
Date: Fri, 25 May 2007 10:02:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched_clock(): cleanups
Message-ID: <20070525080258.GA21446@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525072512.GA12683@elte.hu> <20070525072641.GA13025@elte.hu> <a781481a0705250035q2173234dp4f6cc4d103fced5c@mail.gmail.com> <1180078773.7348.31.camel@twins> <20070525075824.GD8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525075824.GD8094@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Propose a better way to code this then? It's not my fault that dealing 
> with callbacks in C is so messy. _here just massages one callback 
> prototype (smp_call_function's) into another (cpufreq's) because both 
> callbacks do the same in this case.

see the last iteration of the cleanups i did. Naming the function after 
what it does, and prefixing the preempt-unsafe one __ does the trick.

> The r_s_f BTW stands for resync_sc_freq which is a function earlier in 
> the file and should be familiar to a serious reader.

I consider myself a serious reader and it wasnt obvious to me. Names 
must always be descriptive, we cannot hold all the details in our heads 
all the time.

	Ingo
