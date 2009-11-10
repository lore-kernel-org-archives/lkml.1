Return-Path: <linux-kernel-owner+w=401wt.eu-S1751557AbZKJFSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbZKJFSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZKJFSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:18:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZKJFR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:17:59 -0500
Date: Tue, 10 Nov 2009 06:17:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Naohiro Ooiwa <nooiwa@miraclelinux.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
Message-ID: <20091110051734.GG7897@elte.hu>
References: <4AEACFBF.4060108@miraclelinux.com>
 <20091030143333.414ea29c.akpm@linux-foundation.org>
 <1256939158.1917.43.camel@Joe-Laptop.home>
 <1256944907.1917.109.camel@Joe-Laptop.home>
 <20091109134914.70de28cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109134914.70de28cf.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 30 Oct 2009 16:21:47 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > +#define pr_emerg_rl(fmt, ...) \
> > +        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_alert_rl(fmt, ...) \
> > +        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_crit_rl(fmt, ...) \
> > +        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_err_rl(fmt, ...) \
> > +        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_warning_rl(fmt, ...) \
> > +        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_notice_rl(fmt, ...) \
> > +        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_info_rl(fmt, ...) \
> > +        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> 
> Would prefer pr_emerg_ratelimited personally.  It's longer, but one 
> doesn't ask "wtf does _rl" mean and it avoids having two identifiers 
> which refer to the same thing.

Yeah. It will be rarely used so that it wont ever really be 'obvious at 
a glance', even to folks well versed in kernel source code details.

	Ingo
