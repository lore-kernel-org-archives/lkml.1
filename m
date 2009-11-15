Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZKOIiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZKOIiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZKOIiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:38:05 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59762 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZKOIiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:38:04 -0500
Date: Sun, 15 Nov 2009 17:38:04 +0900 (JST)
Message-Id: <20091115.173804.07271244.mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091115022135.GA5427@nowhere>
References: <20091113105126.GC5243@nowhere>
	<20091115.102011.227780670.mitake@dcl.info.waseda.ac.jp>
	<20091115022135.GA5427@nowhere>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Date: Sun, 15 Nov 2009 03:21:38 +0100

> On Sun, Nov 15, 2009 at 10:20:11AM +0900, Hitoshi Mitake wrote:
> > > Thanks :)
> > > I haven't started it yet, because of some other things I need to finish.
> > > 
> > > Would you be interested in starting it?
> > 
> > Yes, I'm very interested in it!
> 
> 
> 
> Great!
> 
>  
> > > Such a tool would be very useful to profile the kernel locking.
> > > 
> > > It would be nice to use design close to what perf sched does:
> > > having an lock event structure that provides callbacks for each
> > > lock events so that we can easily plug various plugin inside.
> > > 
> > > It's just a suggestion in case you are interested and have time
> > > for that. Otherwise I'll do it later.
> > > 
> > > Hm?
> > 
> > I'd like to do that.
> > But I'm an only newbie, so it may take a week (or more).
> 
> 
> Don't worry about that. Take your time.
> 
> 
> > So If you finish this work, please post and disregard me :)
> 
> 
> No if you take it I won't start a concurrent work.
> 
> Don't hesitate if you have questions. This will be the first tool
> (at least that I'm aware of) that post-processes the lock
> event so you may encounter weird things, missing events,
> unappropriate sequences, or any bad things we haven't yet seen.

Thanks. Of course, I'll not hesitate at questioning :)

> 
> And don't forget to use -M on perf record to record
> the lock events so that you have them multiplexed across cpus
> and hence well ordered wrt time. If later we need something that
> scales better, we can still drop the use of -M and do the reordering
> from userspace.

Thanks for your advice! I'll do my best.

