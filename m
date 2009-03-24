Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbZCXVGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbZCXVGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZCXVGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:06:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZCXVGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:06:01 -0400
Date: Tue, 24 Mar 2009 22:05:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, ia6432@inbox.ru,
       roland@redhat.com, tglx@linutronix.de
Subject: Re: [tip:timers/urgent] posix timers: fix RLIMIT_CPU && fork()
Message-ID: <20090324210536.GB14067@elte.hu>
References: <20090323193411.GA17514@redhat.com> <tip-37bebc70d7ad4144c571d74500db3bb26ec0c0eb@git.kernel.org> <20090324182651.GA13408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324182651.GA13408@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 03/23, Oleg Nesterov wrote:
> >
> > Commit-ID:  37bebc70d7ad4144c571d74500db3bb26ec0c0eb
> > Gitweb:     http://git.kernel.org/tip/37bebc70d7ad4144c571d74500db3bb26ec0c0eb
> > Author:     Oleg Nesterov <oleg@redhat.com>
> > AuthorDate: Mon, 23 Mar 2009 20:34:11 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 23 Mar 2009 20:43:35 +0100
> >
> > posix timers: fix RLIMIT_CPU && fork()
> >
> > See http://bugzilla.kernel.org/show_bug.cgi?id=12911
> >
> > copy_signal() copies signal->rlim, but RLIMIT_CPU is "lost". Because
> > posix_cpu_timers_init_group() sets cputime_expires.prof_exp = 0 and thus
> > fastpath_timer_check() returns false unless we have other cpu timers.
> >
> > This is the minimal fix for 2.6.29 (tested) and 2.6.28. The patch is not
> > optimal,
> 
> Ingo, please drop this patch, it is very suboptimal.

suboptimal why?

> My intent was to make the obviously correct patch for 2.6.29, but 
> since it was already released I'll send another one.

Please send it - thanks.

	Ingo
