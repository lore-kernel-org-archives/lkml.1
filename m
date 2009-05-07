Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZEGIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZEGIKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZEGIJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:09:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZEGIJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:09:40 -0400
Date: Thu, 7 May 2009 10:09:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/events: fix concurrent access to
	ftrace_events list
Message-ID: <20090507080914.GA12285@elte.hu>
References: <4A00F709.3080800@cn.fujitsu.com> <tip-20c8928abe70e204bd077ab6cfe23002d7788983@git.kernel.org> <4A028993.7020509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A028993.7020509@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> tip-bot for Li Zefan wrote:
> > Commit-ID:  20c8928abe70e204bd077ab6cfe23002d7788983
> > Gitweb:     http://git.kernel.org/tip/20c8928abe70e204bd077ab6cfe23002d7788983
> > Author:     Li Zefan <lizf@cn.fujitsu.com>
> > AuthorDate: Wed, 6 May 2009 10:33:45 +0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 6 May 2009 10:38:19 +0200
> > 
> > tracing/events: fix concurrent access to ftrace_events list
> > 
> 
> There is a deadlock in this patch, and I sent out a v2 patch and
> expected it to be applied:
> 	http://lkml.org/lkml/2009/5/6/26

ah, i probably already had the first one applied.

> Below is a fix on top of this patch. Sorry for my carelessness.

thanks, applied. No need to be sorry!

btw., we might want to add self-tests for filter functionality too 
perhaps?

	Ingo
