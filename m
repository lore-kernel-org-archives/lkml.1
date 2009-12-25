Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZLYSjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZLYSjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 13:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbZLYSjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 13:39:53 -0500
Received: from mail.perches.com ([173.55.12.10]:1420 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361AbZLYSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 13:39:52 -0500
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       efault@gmx.de, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1261756819.4937.216.camel@laptop>
References: <1261315437.4314.6.camel@laptop>
	 <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
	 <20091225132642.GA1419@ucw.cz>  <1261756819.4937.216.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 10:39:46 -0800
Message-ID: <1261766387.2568.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-25 at 17:00 +0100, Peter Zijlstra wrote:
> On Fri, 2009-12-25 at 14:26 +0100, Pavel Machek wrote:
> > Or alternatively... deprecate pr_*?
> Seems like a fine idea, here's the patch.
> Happy X-mas ;
> git grep -l "\<pr_" | grep -v "kernel\.h" | while read file; 
> do 
> 	sed -i -e 's/pr_emerg(/printk(KERN_EMERG /g' 	\
> 	    -e 's/pr_alert(/printk(KERN_ALERT /g'	\

A lump of coal for you.

1.3 megabytes?

The sed script doesn't match the patch.

Where pr_fmt is defined, the translations are not correct
and need the additional pr_fmt provided format and args.


