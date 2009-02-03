Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZBCFb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZBCFb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZBCFbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:31:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZBCFbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:31:20 -0500
Date: Tue, 3 Feb 2009 06:31:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] trace: let boot trace be chosen by command line
Message-ID: <20090203053108.GD28361@elte.hu>
References: <20090203023830.440860800@goodmis.org> <20090203024358.531245194@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203024358.531245194@goodmis.org>
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

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Now that we have a working ftrace=<tracer> function, make the boot
> tracer get activated by it. This way we can turn it on or off without
> recompiling the kernel, as well as keeping the selftests on. The
> selftests are disabled whenever a default tracer starts running.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/Kconfig      |    7 +++----
>  kernel/trace/trace.c      |    5 +----
>  kernel/trace/trace_boot.c |   11 +++++++----
>  3 files changed, 11 insertions(+), 12 deletions(-)

Applied to tip/tracing/ftrace, thanks Steve!

	Ingo
