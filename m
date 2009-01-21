Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbZAUL7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbZAUL7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762310AbZAUL7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:59:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36889 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760205AbZAUL7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:59:11 -0500
Date: Wed, 21 Jan 2009 12:59:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Riesen <fork0@users.sf.net>
Subject: Re: [Bug #12468] Crash in acpi_cpufreq_init
Message-ID: <20090121115901.GC22054@elte.hu>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.sgH.t9QdJB@chimera> <81b0412b0901191633y130c4cf0w5531af81c3749ee2@mail.gmail.com> <20090120142312.GB10224@elte.hu> <81b0412b0901201435mabecad3i66957a6463140b82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81b0412b0901201435mabecad3i66957a6463140b82@mail.gmail.com>
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


* Alex Riesen <raa.lkml@gmail.com> wrote:

> 2009/1/20 Ingo Molnar <mingo@elte.hu>:
> >
> > * Alex Riesen <raa.lkml@gmail.com> wrote:
> >
> >> 2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > This message has been generated automatically as a part of a report
> >> > of recent regressions.
> >> >
> >> > The following bug entry is on the current list of known regressions
> >> > from 2.6.28.  Please verify if it still should be listed and let me know
> >> > (either way).
> >> >
> >>
> >> The regression is still present.
> >
> > should be fixed by the pending x86 fixes:
> >
> >   git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> >
> > does it work fine if you pull that tree?
> 
> Yep. No crashing anymore. The commits starting from 31ad908 (work_on_cpu...)
> seem to do the fixing.

okay, great. It's all in the queue to Linus now.

	Ingo
