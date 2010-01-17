Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890Ab0AQGxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab0AQGxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 01:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758Ab0AQGxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 01:53:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0AQGxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 01:53:03 -0500
Date: Sun, 17 Jan 2010 07:50:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [GIT PULL] perf event scheduling updates
Message-ID: <20100117065051.GA31505@elte.hu>
References: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263649209-4343-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/scheduling branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/scheduling
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (4):
>       perf/core: Split context's event group list into pinned and non-pinned lists
>       list: Introduce list_rotate_left()
>       perf: Round robin flexible groups of events using list_rotate_left()
>       perf: Export software-only event group characteristic as a flag
> 
> 
>  include/linux/list.h       |   14 +++
>  include/linux/perf_event.h |    8 +-
>  kernel/perf_event.c        |  262 +++++++++++++++++++++++++++-----------------
>  3 files changed, 181 insertions(+), 103 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
