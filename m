Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZAKMFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZAKMFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZAKMFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:05:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbZAKMFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:05:21 -0500
Date: Sun, 11 Jan 2009 13:05:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 1/2] kernel/fork.c: unused variable 'ret'
Message-ID: <20090111120510.GB27796@elte.hu>
References: <1231664662-17104-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231664662-17104-1-git-send-email-steven@uplinklabs.net>
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


* Steven Noonan <steven@uplinklabs.net> wrote:

> Removed the unused variable.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  kernel/fork.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index ce4003a..fb1f5e9 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -822,7 +822,6 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  {
>  	struct signal_struct *sig;
> -	int ret;
>  
>  	if (clone_flags & CLONE_THREAD) {
>  		atomic_inc(&current->signal->count);

applied to tip/core/urgent, thanks Steve!

	Ingo
