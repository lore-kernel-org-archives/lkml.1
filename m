Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYK1TLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYK1TLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYK1TLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:11:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYK1TLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:11:43 -0500
Date: Fri, 28 Nov 2008 20:11:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: move double_unlock_balance() higher
Message-ID: <20081128191131.GA20081@elte.hu>
References: <20081128190800.GB29909@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128190800.GB29909@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Move double_lock_balance()/double_unlock_balance() higher to fix the following
> with gcc-3.4.6:
> 
>   CC      kernel/sched.o
> In file included from kernel/sched.c:1605:
> kernel/sched_rt.c: In function `find_lock_lowest_rq':
> kernel/sched_rt.c:914: sorry, unimplemented: inlining failed in call to 'double_unlock_balance': function body not available
> kernel/sched_rt.c:1077: sorry, unimplemented: called from here
> make[2]: *** [kernel/sched.o] Error 1
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  kernel/sched.c    |   67 ++++++++++++++++++++++++++----------------------------
>  kernel/sched_rt.c |    4 ---
>  2 files changed, 33 insertions(+), 38 deletions(-)

applied to tip/sched/core, thanks Alexey!

	Ingo
