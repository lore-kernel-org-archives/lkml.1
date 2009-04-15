Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZDOKL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZDOKL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZDOKLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:11:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56360 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZDOKLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:11:46 -0400
Date: Wed, 15 Apr 2009 12:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/4] [GIT PULL] more updates for TRACE_EVENTS for
	modules
Message-ID: <20090415100939.GA9773@elte.hu>
References: <20090415031511.128139334@goodmis.org> <20090415072744.GB18192@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415072744.GB18192@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > Please pull the latest tip/tracing/core tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/core
> > 
> > 
> > Steven Rostedt (4):
> >       tracing/events: fix compile for modules disabled
> >       tracing/events: fix lockdep system name
> >       tracing/events: move trace point headers into include/trace/events
> >       tracing/events: add trace-events-sample
> 
> Pulled, thanks - i'm doing some more tests on it now.
> 
> The include/trace/ structure now looks extremely tidy, kudos!

Ok, preliminary tests passed, so i pushed it out into -tip:master as 
well.

Btw., i have yet to trigger the lock tracing related lockup you saw 
- shouldnt the self-tests have triggered any such lockup?

	Ingo
