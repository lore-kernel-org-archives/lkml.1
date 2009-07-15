Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZGOIUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZGOIUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 04:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZGOIUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 04:20:44 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:47128 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZGOIUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 04:20:44 -0400
Date: Wed, 15 Jul 2009 10:20:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timer fixes for 2.6.31
Message-ID: <20090715082040.GA5038@osiris.boeblingen.de.ibm.com>
References: <alpine.LFD.2.00.0907141755210.2777@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907141755210.2777@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 05:56:02PM +0200, Thomas Gleixner wrote:
> Linus,
> 
> Please pull the latest timers-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> 
> Thanks,
> 
> 	tglx
> 
> ------------------>
> Heiko Carstens (1):
>       timer stats: fix quick check optimization

hmm... this patch was not pulled.

> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index 54648e6..4759917 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -448,7 +448,7 @@ extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
> 
>  static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
>  {
> -	if (likely(!timer->start_pid))
> +	if (likely(!timer->start_site))
>  		return;
>  	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
>  				 timer->function, timer->start_comm, 0);
