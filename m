Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZKIVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZKIVt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZKIVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:49:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbZKIVt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:49:56 -0500
Date: Mon, 9 Nov 2009 13:49:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>, Ingo Molnar <mingo@elte.hu>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
Message-Id: <20091109134914.70de28cf.akpm@linux-foundation.org>
In-Reply-To: <1256944907.1917.109.camel@Joe-Laptop.home>
References: <4AEACFBF.4060108@miraclelinux.com>
	<20091030143333.414ea29c.akpm@linux-foundation.org>
	<1256939158.1917.43.camel@Joe-Laptop.home>
	<1256944907.1917.109.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009 16:21:47 -0700
Joe Perches <joe@perches.com> wrote:

> +#define pr_emerg_rl(fmt, ...) \
> +        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_alert_rl(fmt, ...) \
> +        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_crit_rl(fmt, ...) \
> +        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_err_rl(fmt, ...) \
> +        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_warning_rl(fmt, ...) \
> +        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_notice_rl(fmt, ...) \
> +        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_info_rl(fmt, ...) \
> +        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)

Would prefer pr_emerg_ratelimited personally.  It's longer, but one
doesn't ask "wtf does _rl" mean and it avoids having two identifiers
which refer to the same thing.

