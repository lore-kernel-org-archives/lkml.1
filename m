Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYIGHZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYIGHZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 03:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYIGHZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 03:25:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbYIGHZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 03:25:41 -0400
Date: Sun, 7 Sep 2008 09:25:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: cpu make amd.c more like amd_64.c
Message-ID: <20080907072523.GB14907@elte.hu>
References: <1220771725-26763-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220771725-26763-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 1. make 32bit have early_init_amd_mc and amd_detect_cmp
> 2. seperate init_amd_k5/k6/k7 ...
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/cpu/amd.c    |  396 ++++++++++++++++++++++++-------------------
>  arch/x86/kernel/cpu/amd_64.c |   17 +
>  include/asm-x86/processor.h  |    4 
>  3 files changed, 236 insertions(+), 181 deletions(-)

applied to tip/x86/unify-cpu-detect, thanks Yinghai.

	Ingo
