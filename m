Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZBOUQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZBOUQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZBOUQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:16:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZBOUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:16:37 -0500
Date: Sun, 15 Feb 2009 21:16:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Henrik Austad <henrik@austad.us>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterez@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] idle_at_tick is only used when CONFIG_SMP is set
Message-ID: <20090215201624.GA32604@elte.hu>
References: <1234553745-21640-1-git-send-email-henrik@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234553745-21640-1-git-send-email-henrik@austad.us>
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


* Henrik Austad <henrik@austad.us> wrote:

> The idle_at_tick in struct rq is only used in SMP settings
> and it does not make sense to have this in the rq in an UP setup.
> 
> Signed-off-by: Henrik Austad <henrik@austad.us>
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied to tip:sched/cleanups, thanks Henrik!

	Ingo
