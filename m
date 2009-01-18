Return-Path: <linux-kernel-owner+w=401wt.eu-S934986AbZARSWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986AbZARSWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZARSWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:22:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52580 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZARSWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:22:41 -0500
Date: Sun, 18 Jan 2009 19:22:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: linux-kernel@vger.kernel.org, hannes@cmpxchg.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH] softlockup: fix potential race in hung_task when
	resetting timeout
Message-ID: <20090118182236.GB24570@elte.hu>
References: <20090116171832.GA18799@elte.hu> <20090117183148.GA20173@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117183148.GA20173@google.com>
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

> Patch against tip/core/softlockup.
> 
> ---
> 
> A potential race exists if sysctl_hung_task_timeout_secs is reset to 0
> while inside check_hung_uniterruptible_tasks(). If check_task() is
> entered, a comparison with 0 will result in a false hung_task being
> detected.
> 
> If sysctl_hung_task_panic is set, the system will panic.
> 
> Signed-off-by: Mandeep Singh Baines <msb@google.com>
> ---
>  kernel/hung_task.c |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)

Applied to tip/core/softlockup, thanks Mandeep!

	Ingo
