Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZBMKEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZBMKEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZBMKEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:04:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbZBMKEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:04:08 -0500
Date: Fri, 13 Feb 2009 11:03:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, wli@holomorphy.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [git pull] sched: do not account for NMIs
Message-ID: <20090213100319.GA1300@elte.hu>
References: <alpine.DEB.1.10.0902121422000.15469@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902121422000.15469@gandalf.stny.rr.com>
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
>       sched: do not account for NMIs
> 
> ----
>  include/linux/hardirq.h |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)

pulled into tip:tracing/ftrace, thanks Steve!

Btw., any progress on that ia64/etc. build failure related to the NMI
changes? This regression is blocking the linux-next and -mm exposure
of the latest ftrace changes.

	Ingo
