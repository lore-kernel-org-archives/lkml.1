Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZAFJub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZAFJub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZAFJuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:50:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZAFJuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:50:21 -0500
Date: Tue, 6 Jan 2009 10:50:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix double kfree
Message-ID: <20090106095002.GA961@elte.hu>
References: <496326BA.60605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496326BA.60605@cn.fujitsu.com>
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

> Impact: fix double kfree in failure path
> 
> It's not the responsibility of init_rootdomain() to free root_domain
> allocated by alloc_rootdomain().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)

applied to tip/sched/urgent, thanks!

	Ingo
