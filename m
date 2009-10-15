Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZJOGne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZJOGne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZJOGne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:43:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbZJOGnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:43:33 -0400
Date: Thu, 15 Oct 2009 08:42:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 12/13] [PATCH 12/13] perf tools: handle - and + in
	parsing trace print format
Message-ID: <20091015064240.GC11645@elte.hu>
References: <20091014194330.980165492@goodmis.org> <20091014194400.330843045@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014194400.330843045@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The opterators '-' and '+' are not handled in the trace print format.
> 
> To do: '++' and '--'.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  tools/perf/Makefile                 |    2 +-
>  tools/perf/util/trace-event-parse.c |    6 ++++++
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 495eb6d..1172aa7 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -194,7 +194,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
>  
> -CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
> +CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)

hm, why does this patch change the Makefile?

i've skipped this hunk, it does not appear to be connected to the 
commit.

	Ingo
