Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbYGKN7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbYGKN7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761054AbYGKN5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:57:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760290AbYGKN5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:57:48 -0400
Date: Fri, 11 Jul 2008 15:56:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH 0/3] [PATCH] more sched_clock updates
Message-ID: <20080711135630.GD32159@elte.hu>
References: <20080709041530.668120406@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709041530.668120406@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> ftrace is still seeing jumps in the sched_clock.c code that is not 
> seen in using sched_clock() function itself. The following patches fix 
> some of the issues that I've seen. There is still a slight drift but 
> all my attempts to remove it completely have failed. Patch 3 does the 
> best sofar at keeping the jumps to a minimum.

cool stuff! I've created a new -tip topic branch for your sched-clock 
fixes and enhancements, under tip/sched/clock, and have picked up your 
patches:

 Steven Rostedt (7):
      sched_clock: record from last tick
      sched_clock: widen the max and min time
      sched_clock: stop maximum check on NO HZ
      sched_clock: fix calculation of other CPU
      sched_clock: only update deltas with local reads.
      sched_clock: record TSC after gtod
      sched_clock: and multiplier for TSC to gtod drift

thanks,

	Ingo
