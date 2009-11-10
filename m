Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbZKJHyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbZKJHyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZKJHyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:54:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1300 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZKJHyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:54:16 -0500
Subject: Re: [PATCH] kernel.h: Add printk_ratelimited and pr_<level>_rl
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Naohiro Ooiwa <nooiwa@miraclelinux.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, roland@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, oleg@redhat.com
In-Reply-To: <20091110073909.GA8874@elte.hu>
References: <4AEACFBF.4060108@miraclelinux.com>
	 <20091030143333.414ea29c.akpm@linux-foundation.org>
	 <1256939158.1917.43.camel@Joe-Laptop.home>
	 <1256944907.1917.109.camel@Joe-Laptop.home>
	 <20091109134914.70de28cf.akpm@linux-foundation.org>
	 <20091110051734.GG7897@elte.hu> <1257838493.21088.6.camel@twins>
	 <20091110073909.GA8874@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 23:54:21 -0800
Message-ID: <1257839661.2377.33.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 08:39 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Is there a reason for all this pr_ nonsense? will we depricate printk()?
> Yes, pr_*() has established itself as a printk shortcut. The benefits 
> of: pr_info("stuff\n"); versus: printk(KERN_INFO "stuff\n");
> are sufficiently large:
>  - it's shorter by 9 characters (more than a level of indentation)
>  - you cannot forget to add a KERN_ prefix - which is required for 98% 
>    of all printks but which is forgotten from 50% of the submitted 
>    patches.
> so pr_*(), while named in a sucky way (all 2 letter abbrevs are sucky), 
> has advantages, makes stuff more readable and reduces churn.

pr_*()s can be prefixed by pr_fmt
pr_*()s could save text space by storing pr_fmt once


