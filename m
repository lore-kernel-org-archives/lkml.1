Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZLYSrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZLYSrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 13:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZLYSrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 13:47:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53559 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZLYSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 13:47:39 -0500
Date: Fri, 25 Dec 2009 19:47:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, torvalds@linux-foundation.org, efault@gmx.de,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
Message-ID: <20091225184731.GA8438@elf.ucw.cz>
References: <1261315437.4314.6.camel@laptop>
 <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
 <20091225132642.GA1419@ucw.cz>
 <1261756819.4937.216.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261756819.4937.216.camel@laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-25 17:00:19, Peter Zijlstra wrote:
> On Fri, 2009-12-25 at 14:26 +0100, Pavel Machek wrote:
> 
> > Or alternatively... deprecate pr_*?
> 
> Seems like a fine idea, here's the patch.

Actually... I guess I'd slightly prefer the opposite patch. printk()
has a place for quick hacks, but...

pr_err() 

is way shorter 

printk(KERN_ERR )

and forces you to specify log level. 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
