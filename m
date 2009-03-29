Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZC2SCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZC2SCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 14:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZC2SCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 14:02:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49331 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZC2SCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 14:02:39 -0400
Date: Sun, 29 Mar 2009 20:02:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] blktrace: last round of fixes
Message-ID: <20090329180235.GC5178@kernel.dk>
References: <49CC6691.7050103@cn.fujitsu.com> <20090328224640.GA2465@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328224640.GA2465@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28 2009, Ingo Molnar wrote:
> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > This is the last round of fixes for blktrace, I hope.  :) 
> > 
> > Changelog v1 -> v2:
> >   - fix a bug in "blktrace: make classic output more classic",
> >     and rebase other patches.
> >   - re-order patches.
> >   - a new patch for filtering BLK_TN_MESSAGE
> > 
> > [PATCH v2 1/6] trace: make 'mem' argument of trace_seq_putmem() const
> > [PATCH v2 2/6] blktrace: make classic output more classic
> > [PATCH v2 3/6] blktrace: fix blk_probes_ref chaos
> > [PATCH v2 4/6] blktrace: fix memory leak when freeing struct blk_io_trace
> > [PATCH v2 5/6] blktrace: extract duplidate code
> > [PATCH v2 6/6] blktrace: print out BLK_TN_MESSAGE properly
> > ---
> >  blktrace.c     |  188 +++++++++++++++++++++++++++++++++------------------------
> >  trace_output.c |    6 -
> >  trace_output.h |    5 -
> >  3 files changed, 117 insertions(+), 82 deletions(-)
> 
> Li, Jens - what's your call for v2.6.30, can the blktrace changes go 
> upstream or should i zap the whole thing?
> 
> There are no new -tip test failures here so it's green as far as i'm 
> concerned. It's holding up the tracing tree so we need to decide one 
> way or another.

If Li deems it ready, then it has my blessing as well.

-- 
Jens Axboe

