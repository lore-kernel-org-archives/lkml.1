Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYK1LjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYK1LjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYK1LjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:39:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbYK1LjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:39:06 -0500
Date: Fri, 28 Nov 2008 12:38:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liming Wang <liming.wang@windriver.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] softirq: remove useless function __local_bh_enable
Message-ID: <20081128113855.GC18333@elte.hu>
References: <1227837160-3280-1-git-send-email-liming.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227837160-3280-1-git-send-email-liming.wang@windriver.com>
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


* Liming Wang <liming.wang@windriver.com> wrote:

> __local_bh_enable has been replaced with _local_bh_enable.
> As comments says "it always nests inside local_bh_enable() sections"
> has not been valid now. Also there is no reason to use __local_bh_enable
> anywhere, so we can remove this useless function.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> ---
>  include/linux/bottom_half.h |    1 -
>  kernel/softirq.c            |   14 --------------
>  2 files changed, 0 insertions(+), 15 deletions(-)

applied to tip/core/softirq, thanks!

	Ingo
