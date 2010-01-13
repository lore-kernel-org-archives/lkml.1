Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860Ab0AMM6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0AMM6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473Ab0AMM6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:58:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0AMM6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:58:22 -0500
Date: Wed, 13 Jan 2010 10:58:10 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 5/6] perf tools: Use rb_for_each_entry
Message-ID: <20100113125810.GC2934@ghostprotocols.net>
References: <1262901583-8074-1-git-send-email-acme@infradead.org>
 <1262901583-8074-5-git-send-email-acme@infradead.org>
 <20100113091135.GE24475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113091135.GE24475@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 13, 2010 at 10:11:35AM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Cc: Fr??d??ric Weisbecker <fweisbec@gmail.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  tools/perf/builtin-annotate.c |   19 ++++++-------------
> >  tools/perf/builtin-diff.c     |    5 ++---
> >  tools/perf/builtin-kmem.c     |   12 +++++-------
> >  tools/perf/builtin-sched.c    |   10 ++--------
> >  tools/perf/builtin-top.c      |   10 +++-------
> >  tools/perf/util/symbol.c      |   16 ++++++----------
> >  6 files changed, 24 insertions(+), 48 deletions(-)
> 
> hm, this one doesnt build very well:
> 
> touch .perf.dev.null
>     CC builtin-annotate.o
>     CC builtin-diff.o
>     CC builtin-sched.o
>     CC builtin-top.o
>     CC builtin-kmem.o
>     CC util/symbol.o
> cc1: warnings being treated as errors
> builtin-diff.c: In function 'perf_session__match_hists':
> builtin-diff.c:148: error: implicit declaration of function 'rb_for_each_entry'

Checking and will resend shortly.

- Arnaldo
