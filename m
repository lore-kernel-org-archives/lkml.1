Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbZKJHd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbZKJHd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZKJHdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:33:55 -0500
Received: from viefep18-int.chello.at ([62.179.121.38]:38333 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZKJHdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:33:55 -0500
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       Naohiro Ooiwa <nooiwa@miraclelinux.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
In-Reply-To: <20091110051734.GG7897@elte.hu>
References: <4AEACFBF.4060108@miraclelinux.com>
	 <20091030143333.414ea29c.akpm@linux-foundation.org>
	 <1256939158.1917.43.camel@Joe-Laptop.home>
	 <1256944907.1917.109.camel@Joe-Laptop.home>
	 <20091109134914.70de28cf.akpm@linux-foundation.org>
	 <20091110051734.GG7897@elte.hu>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 08:34:53 +0100
Message-Id: <1257838493.21088.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 06:17 +0100, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 30 Oct 2009 16:21:47 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > +#define pr_emerg_rl(fmt, ...) \
> > > +        printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
> > > +#define pr_alert_rl(fmt, ...) \
> > > +        printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
> > > +#define pr_crit_rl(fmt, ...) \
> > > +        printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
> > > +#define pr_err_rl(fmt, ...) \
> > > +        printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
> > > +#define pr_warning_rl(fmt, ...) \
> > > +        printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
> > > +#define pr_notice_rl(fmt, ...) \
> > > +        printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> > > +#define pr_info_rl(fmt, ...) \
> > > +        printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> > 
> > Would prefer pr_emerg_ratelimited personally.  It's longer, but one 
> > doesn't ask "wtf does _rl" mean and it avoids having two identifiers 
> > which refer to the same thing.
> 
> Yeah. It will be rarely used so that it wont ever really be 'obvious at 
> a glance', even to folks well versed in kernel source code details.

Is there a reason for all this pr_ nonsense? will we depricate printk()?

