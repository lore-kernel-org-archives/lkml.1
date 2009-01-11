Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZAKBlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZAKBlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZAKBk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:40:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43035 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbZAKBkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:40:55 -0500
Date: Sun, 11 Jan 2009 02:40:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: partly revert "sched debug: remove NULL
	checking in print_cfs_rt_rq()"
Message-ID: <20090111014050.GM12885@elte.hu>
References: <49685193.6010302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49685193.6010302@cn.fujitsu.com>
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

> Impact: avoid accessing NULL tg.css->cgroup
> 
> In commit 0a0db8f5c9d4bbb9bbfcc2b6cb6bce2d0ef4d73d, I removed checking
> NULL tg.css->cgroup, but I realized I was wrong when I found reading
> /proc/sched_debug can race with cgroup_create().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched_debug.c |   21 +++++++++++++++++----
>  1 files changed, 17 insertions(+), 4 deletions(-)

applied to tip/sched/urgent, thanks!

	Ingo
