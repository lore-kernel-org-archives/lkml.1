Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZFGNou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZFGNou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZFGNom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:44:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54354 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbZFGNol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:44:41 -0400
Date: Sun, 7 Jun 2009 15:44:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing/branch-tracer: PROFILE_BRANCHES_PER_CPU must
	depend on SMP
Message-ID: <20090607134431.GF12088@elte.hu>
References: <20090606073128.GA7321@elte.hu> <1244299043-7613-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244299043-7613-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull this fixlet, made against tip:tracing/branch-tracer.
> It fixes a build failure you've reported recently.
> 
> Thanks.
> 
> The following changes since commit e482f8395f215e0ad6557b2722cd9b9b308035c4:
>   Steven Rostedt (1):
>         tracing/branch-profiler: add option to profile branches per cpu
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/branch-tracer
> 
> Frederic Weisbecker (1):
>       tracing/branch-tracer: PROFILE_BRANCHES_PER_CPU must depend on SMP
> 
>  kernel/trace/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks! I've reactivated it in tip:master - lets see how 
well it goes in testing ... the branch tracer is quite intrusive. 
(perhaps a bit too intrusive...)

	Ingo
