Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZAKDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZAKDu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZAKDuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:50:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZAKDuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:50:20 -0500
Date: Sun, 11 Jan 2009 04:49:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH 2/2] kprobes: check CONFIG_FREEZER instead of CONFIG_PM
Message-ID: <20090111034933.GB28520@elte.hu>
References: <200901062112.29227.rjw@sisk.pl> <200901062115.33286.rjw@sisk.pl> <20090107121659.GA16268@elte.hu> <alpine.LFD.2.00.0901091530090.16697@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901091530090.16697@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> > > Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
> > > depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.
> > > 
> > > This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
> > > and CONFIG_FREEZER=n.
> > > 
> > > Reported-by: Cheng Renquan <crquan@gmail.com>
> > > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  arch/ia64/kernel/kprobes.c |    2 +-
> > >  arch/x86/kernel/kprobes.c  |    2 +-
> > >  kernel/kprobes.c           |    2 +-
> > >  3 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > looks good, the x86 bits:
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> man, we have too many config options:-)

Agreed :-/

The idea is that of learning-via-pain: many config options cause many 
fixes, which causes people to reduce config options. At least that's the 
theory ;-) /me looks at his .config size and wonders

	Ingo
