Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZJLJM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZJLJM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZJLJM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:12:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbZJLJM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:12:26 -0400
Date: Mon, 12 Oct 2009 11:11:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/1] perf tools: Move threads & last_match to threads.c
Message-ID: <20091012091134.GC24031@elte.hu>
References: <1255279254-9956-1-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255279254-9956-1-git-send-email-acme@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> This was just being copy'n'pasted all over.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-annotate.c |   18 +++++++-----------
>  tools/perf/builtin-report.c   |   17 +++++++----------
>  tools/perf/builtin-sched.c    |   15 ++++++---------
>  tools/perf/builtin-trace.c    |    9 +++------
>  tools/perf/util/thread.c      |   40 ++++++++++++++++++----------------------
>  tools/perf/util/thread.h      |   12 ++++--------
>  6 files changed, 45 insertions(+), 66 deletions(-)

hm, mind refreshing this against latest -tip? It doesnt apply anymore:

Hunk #2 FAILED at 635.
Hunk #3 FAILED at 1036.
Hunk #4 FAILED at 1052.
Hunk #5 succeeded at 1122 (offset -5 lines).
Hunk #6 succeeded at 1651 (offset 65 lines).
Hunk #7 succeeded at 1657 (offset -2 lines).
3 out of 7 hunks FAILED -- rejects in file tools/perf/builtin-sched.c
patching file tools/perf/builtin-trace.c
patching file tools/perf/util/thread.c
Hunk #1 FAILED at 6.
Hunk #2 FAILED at 55.
Hunk #3 succeeded at 62 (offset -4 lines).
Hunk #4 FAILED at 84.
Hunk #5 succeeded at 197 (offset -14 lines).
3 out of 5 hunks FAILED -- rejects in file tools/perf/util/thread.c
patching file tools/perf/util/thread.h
Hunk #1 FAILED at 15.
1 out of 1 hunk FAILED -- rejects in file tools/perf/util/thread.h

or have i missed some prereq patch?

	Ingo
