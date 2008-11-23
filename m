Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYKWQt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYKWQt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYKWQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:49:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbYKWQtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:49:47 -0500
Date: Sun, 23 Nov 2008 17:49:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API :
	trace_mark_tp())
Message-ID: <20081123164923.GB11243@elte.hu>
References: <20081114224733.364965865@polymtl.ca> <20081114224948.134716055@polymtl.ca> <20081116075928.GB530@elte.hu> <20081118044403.GA32759@Krystal> <20081118163037.GD8088@elte.hu> <20081123164012.GA16962@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123164012.GA16962@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > ... and in that sense i'd love to see lttng become a "super ftrace 
> > plugin", and be merged upstream ASAP.
> 
> Hrm, a big part of LTTng is its optimized buffering mechanism, which 
> has been more tested and is more flexible than the one currently 
> found in ftrace (it has supported lockless NMI-safe tracing for over 
> 2 years). It also separates the various tracing layers in separated 
> modules, which helps not mixing the buffer management layer with the 
> timestamping layer and with the memory backend layer.. I am opened 
> to try to merge ftrace and lttng together, but I think it will be 
> more than a simple "make lttng a ftrace plugin".

Sure, it will certainly be a fair bit of (interesting and useful!) 
work.

But it's something we should do iteratively, instead of merging a 
parallel framework. Steve's ring-buffer should be a fair step in the 
right direction. Could we improve on that?

i see nothing in the feature list of LTTng that we wouldnt want to 
have for ftrace, agreed? And we could do an ftrace tracer named 
'LTTng' which would interact with lttng userspace in the customary 
way.

	Ingo
