Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZHLJ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZHLJ1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZHLJ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:27:20 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53291 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZHLJ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gFQmqFSyMA5p55oq0i4IVHL3LTSnN4MxpPtsutDJbBYexw3l29kmexASMvGLbbstAK
         HUkyerNF8LzkVXgRN0evHbxrB5bRmd3hsp77Qi3btbUzCVvqjOA6+mSX+jI8jkCqrsnV
         qv6FoK0DURNu48+ftH4gNQVs7S4PT5nQfLnDg=
Date: Wed, 12 Aug 2009 11:27:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [GIT PULL] perf tools: Factorize common code
Message-ID: <20090812092711.GA6081@nowhere>
References: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:25:59AM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> This set factorizes the common definition of structs, functions,
> variables inside perf tools to make it easier for perf trace to
> be created.
> 
> I guess this patchset only factorizes 10 % of what could be done,
> the largest part is the intersection between perf report and perf
> annotate. It's a lot of work.
> 
> I guess I will do the rest in separate patchsets while writing
> perf trace.
> 
> Thanks,
> Frederic.
> 
> 
> The following changes since commit 9f8666971185b86615a074bcac67c90fdf8af8bc:
>   Brice Goglin (1):
>         perf report: Add raw displaying of per-thread counters
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git ..BRANCH.NOT.VERIFIED..


s/BRANCH.NOT.VERIFIED/"perfcounters/core"


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
>  tools/perf/util/event.h       |   84 +++++++++++++
>  tools/perf/util/map.c         |   97 +++++++++++++++
>  tools/perf/util/symbol.c      |   97 +++++++++++++++
>  tools/perf/util/symbol.h      |   12 ++
>  tools/perf/util/util.h        |    1 +
>  14 files changed, 303 insertions(+), 521 deletions(-)
>  create mode 100644 tools/perf/util/event.h
>  create mode 100644 tools/perf/util/map.c

