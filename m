Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZLTOth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZLTOth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZLTOtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:49:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZLTOte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:49:34 -0500
Date: Sun, 20 Dec 2009 15:49:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: sched: restore sanity
Message-ID: <20091220144925.GA19608@elte.hu>
References: <1261315437.4314.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261315437.4314.6.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Revert the braindead pr_* crap.
> 
> it's dumb and causes stupid "sched: " strings all over the place.
> 
> ---
>  kernel/sched.c          |   89 ++++++++++++++++++++++++++---------------------
>  kernel/sched_idletask.c |    2 +-
>  2 files changed, 50 insertions(+), 41 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 720df10..7ffde2a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -26,8 +26,6 @@
>   *              Thomas Gleixner, Mike Kravetz
>   */
>  
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/nmi.h>

that's all that we need to remove i suspect, to get rid of the stupid 
prefixes.

	Ingo
