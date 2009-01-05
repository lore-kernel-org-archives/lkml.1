Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZAEMzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZAEMzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZAEMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:55:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbZAEMzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:55:01 -0500
Date: Mon, 5 Jan 2009 13:54:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [RESEND] sched: mark
	sched_create_sysfs_power_savings_entries() as __init
Message-ID: <20090105125450.GB1023@elte.hu>
References: <4961E98D.3050305@cn.fujitsu.com> <4961EC6A.8010008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4961EC6A.8010008@cn.fujitsu.com>
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

> Impact: cleanup
> 
> The only caller is cpu_dev_init() which is marked as __init.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> resend with SOB added
> 
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/sched/urgent, thanks!

	Ingo
