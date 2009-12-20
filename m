Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZLTSzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZLTSzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 13:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZLTSzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 13:55:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1335 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbZLTSzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 13:55:04 -0500
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
From: Joe Perches <joe@perches.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-3df0fc5b2e9d8092dcaeb5ae0b6753d85c851d66@git.kernel.org>
References: <1261315437.4314.6.camel@laptop>
	 <tip-3df0fc5b2e9d8092dcaeb5ae0b6753d85c851d66@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 10:55:00 -0800
Message-ID: <1261335300.30458.209.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 18:06 +0000, tip-bot for Peter Zijlstra wrote:
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 720df10..7ffde2a 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7828,44 +7828,48 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
>  	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
>  
>  	if (!(sd->flags & SD_LOAD_BALANCE)) {
> -		pr_cont("does not load-balance\n");
> +		printk("does not load-balance\n");
>  		if (sd->parent)
> -			pr_err("ERROR: !SD_LOAD_BALANCE domain has parent\n");
> +			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
> +					" has parent");

Missing a trailing \n.


