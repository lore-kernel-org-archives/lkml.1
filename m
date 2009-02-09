Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZBIJx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZBIJx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZBIJxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:53:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZBIJxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:53:16 -0500
Date: Mon, 9 Feb 2009 10:52:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 3/5] tracing/power: move the power trace headers to a
	dedicated file
Message-ID: <20090209095254.GC14402@elte.hu>
References: <498e1762.1358560a.0f3f.ffffa0a7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498e1762.1358560a.0f3f.ffffa0a7@mx.google.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: cleanup
> 
> Move the power tracer headers to trace/power.h to keep ftrace.h and power bits
> more easy to maintain as separated topics.
> 
> Cc: Arjan van de Ven <arjan@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
>  arch/x86/kernel/process.c                  |    2 +-
>  include/linux/ftrace.h                     |   30 ------------------------
>  include/trace/power.h                      |   35 ++++++++++++++++++++++++++++
>  kernel/trace/trace.h                       |    1 +
>  kernel/trace/trace_power.c                 |    2 +-
>  6 files changed, 39 insertions(+), 33 deletions(-)
>  create mode 100644 include/trace/power.h

Applied to tip/tracing/ftrace, thanks Frederic!

	Ingo
