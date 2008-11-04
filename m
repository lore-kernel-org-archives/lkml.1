Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYKDJXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYKDJXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKDJXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:23:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35339 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYKDJXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:23:21 -0500
Date: Tue, 4 Nov 2008 10:23:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched debug: remove NULL checking in print_cfs/rt_rq()
Message-ID: <20081104092308.GK23790@elte.hu>
References: <49100501.8050002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49100501.8050002@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0090]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> cfs->tg is initialized in init_tg_cfs_entry() with tg != NULL, and
> will never be invalidated to NULL. And the underlying cgroup of a
> valid task_group is always valid.
> 
> Same for rt->tg.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched_debug.c |   14 ++------------
>  1 files changed, 2 insertions(+), 12 deletions(-)

applied to tip/sched/core, thanks!

	Ingo
