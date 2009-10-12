Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZJLHNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZJLHNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZJLHNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:13:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51631 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbZJLHNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:13:38 -0400
Date: Mon, 12 Oct 2009 09:12:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf timechart: Work around commit 42e59d7d19dc4b4
Message-ID: <20091012071255.GB8202@elte.hu>
References: <20091007125601.415e7898@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007125601.415e7898@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> >From 07c039ee370f49a0c5fc690ba473d42d27ccb022 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 7 Oct 2009 12:27:07 -0700
> Subject: [PATCH] perf timechart: Work around commit 42e59d7d19dc4b4
> 
> Commit 42e59d7d19dc4b4 introduced a sample frequency framework..
> .. however it unfortunately changed how perf events get recorded,
> and caused timechart to miss events to the point that timechart
> became useless.
> 
> This patch causes the timechart code to use -F 0 to not use the
> new framework when recording timechart data.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  tools/perf/builtin-timechart.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Could you please check latest -tip, does it work fine now?

Mike's commit:

  7e4ff9e: perf tools: Fix counter sample frequency breakage

should fix the breakage 42e59d7d19dc4b4 introduced in perf timechart.

	Ingo
