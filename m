Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZBIKFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZBIKFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZBIKFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:05:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBIKFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:05:03 -0500
Date: Mon, 9 Feb 2009 11:04:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH] softlockup: remove timestamp checking from hung_task
Message-ID: <20090209100452.GD20467@elte.hu>
References: <20090206233747.GA8747@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206233747.GA8747@google.com>
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


* Mandeep Singh Baines <msb@google.com> wrote:

> Patch against tip/core/softlockup
> 
> ---
> Impact: saves sizeof(long) bytes per task_struct
> 
> By guaranteeing that sysctl_hung_task_timeout_secs have elapsed between
> tasklist scans we can avoid using timestamps.
> 
> Signed-off-by: Mandeep Singh Baines <msb@google.com>
> ---
>  include/linux/sched.h |    1 -
>  kernel/fork.c         |    8 +++-----
>  kernel/hung_task.c    |   48 +++++++++---------------------------------------
>  3 files changed, 12 insertions(+), 45 deletions(-)

Nice simplification!

Applied to tip/core/softlockup, thanks Mandeep.

(i fixed the one scripts/checkpatch.pl error that your patch triggered)

	Ingo
