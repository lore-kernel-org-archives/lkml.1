Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZKTIzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZKTIzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZKTIzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:55:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZKTIzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:55:49 -0500
Date: Fri, 20 Nov 2009 09:55:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
Message-ID: <20091120085536.GC19778@elte.hu>
References: <4B064AF5.9060208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B064AF5.9060208@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> ---
>  tools/perf/Makefile       |    1 +
>  tools/perf/builtin-kmem.c |  578 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/builtin.h      |    1 +
>  tools/perf/perf.c         |   27 +-
>  4 files changed, 594 insertions(+), 13 deletions(-)
>  create mode 100644 tools/perf/builtin-kmem.c

btw., you might want to add it to command-list.txt as well (in a future 
patch), so that 'kmem' shows up in the default 'perf' output.

Plus a Documentation/perf-kmem.txt file will make sure that 'perf help 
kmem' and 'perf kmem --help' displays a help page, etc.

Thanks,

	Ingo
