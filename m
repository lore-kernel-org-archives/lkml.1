Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZBML7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZBML7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZBML7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:59:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZBML7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:59:36 -0500
Date: Fri, 13 Feb 2009 12:58:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-m68k@vger.kernel.org,
       linux-ia64@vger.kernel.org, kernel@avr32linux.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Tony Luck <tony.luck@intel.com>, Mike Travis <travis@sgi.com>,
       isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [git pull] preempt-count: force hardirq-count to max of 10
Message-ID: <20090213115851.GK15679@elte.hu>
References: <alpine.DEB.1.10.0902121139230.15469@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902121139230.15469@gandalf.stny.rr.com>
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

> Ingo,
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Steven Rostedt (1):
>       preempt-count: force hardirq-count to max of 10
> 
> ----
>  arch/alpha/include/asm/hardirq.h |   13 ----------
>  arch/avr32/include/asm/hardirq.h |   11 --------
>  arch/ia64/include/asm/hardirq.h  |   10 --------
>  include/linux/hardirq.h          |   48 +++++++++++++++++++-------------------
>  4 files changed, 24 insertions(+), 58 deletions(-)

Pulled, thanks Steve.

	Ingo
