Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYGRL21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYGRL21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYGRL2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:28:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbYGRL2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:28:18 -0400
Date: Fri, 18 Jul 2008 13:28:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: pj@sgi.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       menage@google.com, vegard.nossum@gmail.com
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any
	context (take 2)
Message-ID: <20080718112803.GB6875@elte.hu>
References: <1216189268-30122-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216189268-30122-1-git-send-email-maxk@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> From: Max Krasnyanskiy <maxk@qualcomm.com>
> 
> Basically as Paul J. pointed out rebuild_sched_domains() is the only 
> way to rebuild sched domains correctly based on the current cpuset 
> settings. What this means is that we need to be able to call it from 
> different contexts, like cpuhotplug for example. Also if you look at 
> the cpu_active_map patches, the scheduler now calls 
> rebuild_sched_domains() directly from places like 
> arch_init_sched_domains().

please fix the whitespace problems and the misformatted multi-line 
comment as well. (checkpatch will point out where they are)

	Ingo
