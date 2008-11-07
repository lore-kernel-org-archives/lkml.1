Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbYKGHak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbYKGHak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYKGHab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:30:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYKGHab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:30:31 -0500
Date: Fri, 7 Nov 2008 08:30:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: fix memory leak in a failing path
Message-ID: <20081107073025.GB19583@elte.hu>
References: <4913E479.8050505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4913E479.8050505@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> In the failing path, rd is not attached to a sched domain,
> so it causes a leak.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

applied to tip/sched/urgent, thanks!

	Ingo
