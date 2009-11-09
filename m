Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZKIWFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZKIWFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZKIWFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:05:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1268 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbZKIWFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:05:16 -0500
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>, Ingo Molnar <mingo@elte.hu>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
In-Reply-To: <20091109134914.70de28cf.akpm@linux-foundation.org>
References: <4AEACFBF.4060108@miraclelinux.com>
	 <20091030143333.414ea29c.akpm@linux-foundation.org>
	 <1256939158.1917.43.camel@Joe-Laptop.home>
	 <1256944907.1917.109.camel@Joe-Laptop.home>
	 <20091109134914.70de28cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 14:05:20 -0800
Message-ID: <1257804320.12852.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 13:49 -0800, Andrew Morton wrote:
> On Fri, 30 Oct 2009 16:21:47 -0700
> Joe Perches <joe@perches.com> wrote:
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

I don't have a strong opinion either way.
_rl is shorter and that has some value.

I think pr_crit_rl, pr_emerg_rl and pr_alert_rl likely
aren't useful.  Is there a sensible use case for those?

I added them for completeness, but...

