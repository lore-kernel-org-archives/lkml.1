Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYB1Hun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYB1Hun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYB1Huf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:50:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbYB1Huf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:50:35 -0500
Date: Thu, 28 Feb 2008 08:50:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       Max Krasnyanskiy <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-ID: <20080228075010.GA28781@elte.hu>
References: <20080227222103.673194000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227222103.673194000@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> My vision on the direction we should take wrt cpu isolation.
> 
> Next on the list would be figuring out a nice solution to the 
> workqueue flush issue.

nice work Peter, i find this "system sets" extension to cpusets a much 
more elegant (and much more future-proof) solution than the proposed 
spreadout of the limited hack of isolcpus/cpu_isolated_map. It 
concentrates us on a single API and on a single mechanism to handle 
isolation matters. (be that for clustering/supercomputing or real-time 
purposes)

Thanks for insisting on using cpusets for this!

i've queued up your patches in sched-devel.git, and lets make sure this 
has no side-effects on existing functionality. (it shouldnt)

	Ingo
