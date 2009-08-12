Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbZHLLAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbZHLLAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932528AbZHLLAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:00:32 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:58123 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbZHLLAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DWvtZ0URRviaPGLNKr/tYTdvDKcHznDuzTHoQgi+3+atVzSaeHT4TImDLojloYZpXD
         fX+abZEwvq3qJy7J6g6q2hGsvJ/x5Kbp8fh8hB+CXO5X1eGMdQhSsqst9mYKzGL1VwDy
         ypM/IocpyJ/mnJ62Ypp+bZYTWzKiGITdlBhRQ=
Date: Wed, 12 Aug 2009 13:00:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [GIT PULL v2] perf tools: Factorize common code
Message-ID: <20090812110027.GC6081@nowhere>
References: <20090812100851.GA18577@elte.hu> <1250074112-15147-1-git-send-email-fweisbec@gmail.com> <20090812105433.GB7885@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812105433.GB7885@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 12:54:33PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, Aug 12, 2009 at 12:08:51PM +0200, Ingo Molnar wrote:
> > > yeah. I've zapped those commits from perfcounters/core.
> > >
> > >       Ingo
> > 
> > Ok, sorry about that.
> > I've rebuilt a clean tree. It should be fine now.
> 
> btw., you can always check whether there's any missing 
> git-add, via:
> 
>   git ls-files --others


Ah nice tip.


 
> And the safest way to commit is to use 'git commit -a' - 
> that will auto-include new files. (but the tree has to be 
> clean for that)


Well, I always have junks in my directories. .rej/.orig files,
or more especially scripts and tests in the case of the tools/perf
directory. So it's hard to check everything this way.

Note that most of the time I use git-commit -a, but it doesn't include
untracked files AFAICS.


> > 
> > Thanks.
> > 
> > The following changes since commit 9f8666971185b86615a074bcac67c90fdf8af8bc:
> >   Brice Goglin (1):
> >         perf report: Add raw displaying of per-thread counters
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> > 	perfcounters/core
> > 
> > Frederic Weisbecker (3):
> >       perf tools: Factorize high level dso helpers
> >       perf tools: Factorize the event structure definitions in a single file
> >       perf tools: Factorize the map helpers
> > 
> >  tools/perf/Makefile           |    2 +
> >  tools/perf/builtin-annotate.c |  209 +-------------------------------
> >  tools/perf/builtin-record.c   |   20 +---
> >  tools/perf/builtin-report.c   |  274 +----------------------------------------
> >  tools/perf/builtin-stat.c     |    1 -
> >  tools/perf/builtin-top.c      |   24 ----
> >  tools/perf/builtin.h          |    1 +
> >  tools/perf/perf.h             |    1 +
> >  tools/perf/util/callchain.h   |    1 +
> >  tools/perf/util/debug.c       |   22 ++++
> >  tools/perf/util/debug.h       |    5 +
> >  tools/perf/util/event.h       |   84 +++++++++++++
> >  tools/perf/util/map.c         |   97 +++++++++++++++
> >  tools/perf/util/symbol.c      |   97 +++++++++++++++
> >  tools/perf/util/symbol.h      |   12 ++
> >  tools/perf/util/util.h        |    1 +
> >  16 files changed, 330 insertions(+), 521 deletions(-)
> >  create mode 100644 tools/perf/util/debug.c
> >  create mode 100644 tools/perf/util/debug.h
> >  create mode 100644 tools/perf/util/event.h
> >  create mode 100644 tools/perf/util/map.c
> 
> Re-pulled it - it works fine here too - thanks!
> 
> 	Ingo


Cool, thanks.

