Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZDPJyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZDPJyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZDPJyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:54:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbZDPJyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:54:00 -0400
Date: Thu, 16 Apr 2009 11:53:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip
Message-ID: <20090416095347.GA744@elte.hu>
References: <20090416021830.556671772@goodmis.org> <20090416095135.GA18620@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416095135.GA18620@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> This:
> 
> 	if (WARN_ONCE(KERN_CONT "%s: failed! ret: %d\n", sysname, ret)) {
> 		...
> 	}
> 
> would suffice, right?

Please put a "WARNING: " tag into that printout too, so that test 
scripts can pick up such failures automatically.

Thanks,

	Ingo
