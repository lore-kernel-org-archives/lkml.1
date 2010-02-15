Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0BOEur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:50:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab0BOEuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:50:46 -0500
Date: Mon, 15 Feb 2010 05:50:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] tracing fixes
Message-ID: <20100215045024.GC19287@elte.hu>
References: <20100214090913.GA26388@elte.hu>
 <4B78A60B.3030807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B78A60B.3030807@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Ingo,
> 
> Could you push this commit too?
> 
> 5ecaafdbf44b1ba400b746c60c401d54c7ee0863
> kprobes: Add mcount to the kprobes blacklist
> 
> Since this bug can be easily reproduced with kprobe-tracer.

Ok, i've cherry-picked it into urgent.

I'm wondering, how complete is the kprobes blacklist? You can test it by 
putting a probe on every single function in the system via something like:

  for N in $(cut -d' ' -f3 /proc/kallsyms  | cut -f1); do
    perf probe $N
    perf probe -d $N
  done

(note: I havent tested it myself yet.)

Thanks,

	Ingo
