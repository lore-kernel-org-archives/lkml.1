Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZHFMWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZHFMWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZHFMWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:22:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41021 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbZHFMWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:22:51 -0400
Date: Thu, 6 Aug 2009 14:22:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL][2.6.31] ring-buffer/tracing: various
	fixes
Message-ID: <20090806122230.GB13995@elte.hu>
References: <20090806025206.306150861@goodmis.org> <20090806041127.GE25478@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806041127.GE25478@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 05.08.09 22:52:06, Steven Rostedt wrote:
> > 
> > Ingo,
> > 
> > Please pull the latest tip/tracing/urgent tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/urgent
> 
> Steven,
> 
> if there is the chance I would like to see this fix in -rc6 too (I 
> know you wanted to test it):
> 
>  193df82 ring-buffer: Fix advance of reader in rb_buffer_peek()
> 
> You can cherry-pick from my oprofile/master tree or linux-next. 
> The bug throws warnings with oprofile under high loads and I 
> already got bug reports of this.

i remember having triggered something similar in tests too. I've 
cherry-picked it on top of Steve's fixes, for -rc6.

Thanks,

	Ingo
