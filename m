Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZDVK0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZDVK0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZDVK0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:26:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56312 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZDVK0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:26:01 -0400
Date: Wed, 22 Apr 2009 12:25:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][GIT-PULL] tracing/events: protect __get_str()
Message-ID: <20090422102540.GC1115@elte.hu>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0904211749580.10097@gandalf.stny.rr.com> <alpine.DEB.2.00.0904211759540.10097@gandalf.stny.rr.com> <20090421221241.GA6744@nowhere> <alpine.DEB.2.00.0904211820410.9714@gandalf.stny.rr.com> <20090421233253.GB6744@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421233253.GB6744@nowhere>
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

> On Tue, Apr 21, 2009 at 06:21:54PM -0400, Steven Rostedt wrote:
> > It would probably be better to just make the fix now. Just put the fix in 
> > a separate branch to avoid race conditions (if Ingo already did a pull ;-)
> > 
> > -- Steve
> 
> 
> Ok, so this new pull request includes the patches in the previous
> request + your Reviewed/Acked-by + the fix on __get_str() which
> I pasted below. It's also a rebase against latest tip/tracing/core.
> 
> Thanks.
> 
> The following changes since commit 3554228d4289098a8fe5cfd87512ec32a19bbe5a:
>   Steven Rostedt (1):
>         ring-buffer: only warn on wrap if buffer is bigger than two pages
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core-v2
> 
> Frederic Weisbecker (3):
>       tracing/events: provide string with undefined size support
>       tracing/lock: provide lock_acquired event support for dynamic size string
>       tracing/events: protect __get_str()
> 
>  include/trace/events/lockdep.h |    6 +-
>  include/trace/ftrace.h         |   88 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 88 insertions(+), 6 deletions(-)

Pulled, thanks Frederic!

	Ingo
