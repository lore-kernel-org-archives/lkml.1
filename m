Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZLYN1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZLYN1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 08:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZLYN1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 08:27:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34964 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZLYN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 08:27:03 -0500
Date: Fri, 25 Dec 2009 14:26:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, torvalds@linux-foundation.org, peterz@infradead.org,
       efault@gmx.de, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
Message-ID: <20091225132642.GA1419@ucw.cz>
References: <1261315437.4314.6.camel@laptop> <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-20 18:00:38, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
> Gitweb:     http://git.kernel.org/tip/6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Sun, 20 Dec 2009 14:23:57 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 20 Dec 2009 18:45:57 +0100
> 
> sched: Restore printk sanity
> 
> Revert the braindead pr_* crap. (Commit 663997d "sched: Use
> pr_fmt() and pr_<level>()")
> 
> It's dumb and causes stupid "sched: " strings all over the place.

It seems rest of kernel is moving towards pr_*. just removing the
"sched:" would be better for consistency.

Or alternatively... deprecate pr_*?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
