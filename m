Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbZCWRQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbZCWRQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759365AbZCWRQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:16:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33338 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759241AbZCWRQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:16:11 -0400
Date: Mon, 23 Mar 2009 18:15:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, daniel@caiaq.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] kernel/trace/trace_functions_graph.c: fix
	nsecs_str buffer size
Message-ID: <20090323171536.GA6848@elte.hu>
References: <1237824637-28190-1-git-send-email-daniel@caiaq.de> <tip-603b9b9081ae0a1af986b9059a0a5055876ddea9@git.kernel.org> <20090323164745.GB5988@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323164745.GB5988@nowhere>
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

> On Mon, Mar 23, 2009 at 04:42:27PM +0000, Daniel Mack wrote:
> > Commit-ID:  603b9b9081ae0a1af986b9059a0a5055876ddea9
> > Gitweb:     http://git.kernel.org/tip/603b9b9081ae0a1af986b9059a0a5055876ddea9
> > Author:     Daniel Mack <daniel@caiaq.de>
> > AuthorDate: Mon, 23 Mar 2009 17:10:37 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 23 Mar 2009 17:40:51 +0100
> > 
> > kernel/trace/trace_functions_graph.c: fix nsecs_str buffer size
> > 
> > Impact: fix currently inactive buffer-overflow
> > 
> > In kernel/trace/trace_functions_graph.c, print_graph_duration(),
> > len can be as low as 1 or 2, which could make snprintf() write
> > beyond the buffer bounds. (Found by cppcheck, no real-world bug
> > occured)
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > LKML-Reference: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  kernel/trace/trace_functions_graph.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> 
> Ingo, as I explained to Daniel before (I should have Cc you),
> there is no overflow to protect here, so this patch will not
> change anything.
> 
> This is my bad, I should better comment my code.

Yeah - saw your reply, and zapped the commit already. Please add a 
comment in any case.

	Ingo
