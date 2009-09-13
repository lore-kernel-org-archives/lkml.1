Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZIMO7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZIMO7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 10:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZIMO7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 10:59:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZIMO7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 10:59:47 -0400
Date: Sun, 13 Sep 2009 16:59:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/6] [GIT PULL] tracing: automate output for ftrace
	formats
Message-ID: <20090913145931.GA24187@elte.hu>
References: <20090913034302.134417216@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913034302.134417216@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Currently, the output for the format files for the internal ftrace
> plugin entries is done by hand. This becomes difficult to maintain
> and error prone. If a change happens to a structure, it is likely
> that it will not be shown in the format file which binary readers
> of ftrace require.
> 
> This patch series implements the logic that is used by TRACE_EVENT
> to use macros that create the structures and those same macros also
> show the output layout in the format files. This guarantees that the
> structures and the output formats remain in-sync.
> 
> Again, this is based off of tip/tracing/core2
> 
> Please pull the latest tip/tracing/core3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core3

Pulled, thanks a lot Steve!

	Ingo
