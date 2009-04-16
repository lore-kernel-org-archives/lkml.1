Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZDPQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZDPQaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZDPQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:30:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZDPQam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:30:42 -0400
Date: Thu, 16 Apr 2009 18:30:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip
Message-ID: <20090416163015.GA13140@elte.hu>
References: <20090416021830.556671772@goodmis.org> <20090416095135.GA18620@elte.hu> <alpine.DEB.2.00.0904160950340.5262@gandalf.stny.rr.com> <20090416161207.GB14658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416161207.GB14658@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> -tip testing found a boot failure [boot hang]:
> 
> calling  event_trace_self_tests+0x0/0x3ec @ 1
> Running tests on trace events:
> Testing event kfree_skb: <7>bus: 'serio': driver_probe_device: 
> matched device serio1 wid
> bus: 'serio': really_probe: probing driver atkbd with device serio1
> 
> with the attached config.

note, i temporarily disabled the self-tests in tip:tracing/ftrace, 
to allow other tests continue. I did not want to unpull that branch 
from tip:master because the linecount difference and conflict danger 
is large and i presume you'll fix these quickly :-)

	Ingo
