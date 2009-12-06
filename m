Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZLFH6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZLFH6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZLFH6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:58:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47287 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZLFH6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:58:44 -0500
Date: Sun, 6 Dec 2009 08:58:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [GIT PULL] perf/hw-breakpoints: Various updates
Message-ID: <20091206075825.GA7169@elte.hu>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> I have hesitations about the 2 last patches as they should probably
> go into another branch. Their scope is wider than perf as they also
> fix x86-64 stacktraces in general.

Pulled, thanks a lot Frederic! These are some very nice fixes - and the 
call-graph frame linking fixes will improve regular stacktraces as well.

> Tell me if you'd prefer them in a separate tree based on something 
> else.

perf/core is fine. Since Linus pulled them upstream earlier today these 
bits will end up in perf/urgent, please base future tress on that topic 
tree.

Thanks,

	Ingo
