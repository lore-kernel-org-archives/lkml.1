Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbZHLKys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbZHLKys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbZHLKyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:54:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbZHLKyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:54:47 -0400
Date: Wed, 12 Aug 2009 12:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [GIT PULL v2] perf tools: Factorize common code
Message-ID: <20090812105433.GB7885@elte.hu>
References: <20090812100851.GA18577@elte.hu> <1250074112-15147-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250074112-15147-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Aug 12, 2009 at 12:08:51PM +0200, Ingo Molnar wrote:
> > yeah. I've zapped those commits from perfcounters/core.
> >
> >       Ingo
> 
> Ok, sorry about that.
> I've rebuilt a clean tree. It should be fine now.

btw., you can always check whether there's any missing 
git-add, via:

  git ls-files --others

And the safest way to commit is to use 'git commit -a' - 
that will auto-include new files. (but the tree has to be 
clean for that)

> 
> Thanks.
> 
> The following changes since commit 9f8666971185b86615a074bcac67c90fdf8af8bc:
>   Brice Goglin (1):
>         perf report: Add raw displaying of per-thread counters
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> 	perfcounters/core
> 
> Frederic Weisbecker (3):
>       perf tools: Factorize high level dso helpers
>       perf tools: Factorize the event structure definitions in a single file
>       perf tools: Factorize the map helpers
> 
>  tools/perf/Makefile           |    2 +
>  tools/perf/builtin-annotate.c |  209 +-------------------------------
>  tools/perf/builtin-record.c   |   20 +---
>  tools/perf/builtin-report.c   |  274 +----------------------------------------
>  tools/perf/builtin-stat.c     |    1 -
>  tools/perf/builtin-top.c      |   24 ----
>  tools/perf/builtin.h          |    1 +
>  tools/perf/perf.h             |    1 +
>  tools/perf/util/callchain.h   |    1 +
>  tools/perf/util/debug.c       |   22 ++++
>  tools/perf/util/debug.h       |    5 +
>  tools/perf/util/event.h       |   84 +++++++++++++
>  tools/perf/util/map.c         |   97 +++++++++++++++
>  tools/perf/util/symbol.c      |   97 +++++++++++++++
>  tools/perf/util/symbol.h      |   12 ++
>  tools/perf/util/util.h        |    1 +
>  16 files changed, 330 insertions(+), 521 deletions(-)
>  create mode 100644 tools/perf/util/debug.c
>  create mode 100644 tools/perf/util/debug.h
>  create mode 100644 tools/perf/util/event.h
>  create mode 100644 tools/perf/util/map.c

Re-pulled it - it works fine here too - thanks!

	Ingo
