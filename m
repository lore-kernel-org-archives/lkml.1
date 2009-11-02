Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZKBJY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZKBJY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZKBJY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:24:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59423 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbZKBJYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:24:55 -0500
Date: Mon, 2 Nov 2009 10:24:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] Maintain preemptability count even for
	!CONFIG_PREEMPT kernels
Message-ID: <20091102092449.GD8933@elte.hu>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-10-git-send-email-gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257076590-29559-10-git-send-email-gleb@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Gleb Natapov <gleb@redhat.com> wrote:

> Do not preempt kernel. Just maintain counter to know if task can sleep.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> ---
>  include/linux/hardirq.h |    6 ++----
>  include/linux/preempt.h |   22 ++++++++++++++++------
>  kernel/sched.c          |    6 ------
>  lib/kernel_lock.c       |    1 +
>  4 files changed, 19 insertions(+), 16 deletions(-)

Lack of explanation in the changelog and lack of Cc:s.

This whole patch-set should be Cc:-ed to a lot more people, and the acks 
of various maintainers are needed before it can be applied.

	Ingo
