Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZKXPdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZKXPdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbZKXPdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:33:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43212 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096AbZKXPc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:32:59 -0500
Date: Tue, 24 Nov 2009 16:32:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com
Subject: Re: [PATCH] Perf-tools create common process_event functions
Message-ID: <20091124153259.GE21821@elte.hu>
References: <1259073301-11506-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259073301-11506-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Kacur <jkacur@redhat.com> wrote:

> This continues the effort to prevent bit-rot in perf-annotate by using
> common functions for perf-report and perf-annotate where possible.
> 
> This creates the process.[ch] files.
> More functions can be added here after - but this is a working step
> in the process.
> 
> John Kacur (2):
>   perf-tools: Add perf.data to .gitignore
>   perf-tools: Use common process_event functions for annotate and
>     report
> 
>  tools/perf/.gitignore            |    1 +
>  tools/perf/Makefile              |    2 +
>  tools/perf/builtin-annotate.c    |   56 +--------------------------------
>  tools/perf/builtin-report.c      |   63 +------------------------------------
>  tools/perf/util/process_event.c  |   53 +++++++++++++++++++++++++++++++
>  tools/perf/util/process_event.h  |   29 +++++++++++++++++
>  tools/perf/util/process_events.c |   64 ++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/process_events.h |   35 ++++++++++++++++++++
>  8 files changed, 187 insertions(+), 116 deletions(-)
>  create mode 100644 tools/perf/util/process_event.c
>  create mode 100644 tools/perf/util/process_event.h
>  create mode 100644 tools/perf/util/process_events.c
>  create mode 100644 tools/perf/util/process_events.h

Nice cleanups, applied to tip:perf/core, thanks John!

	Ingo
