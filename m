Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbZKOCVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbZKOCVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 21:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZKOCVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 21:21:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:20005 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZKOCVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 21:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M6XKUW8RE9b303EXcpEM4OH/VhnEQt1dXyttg1doE/3VpbQPZROIn/MRzOVJrxCqY1
         eWbYCtqspwJQ9ly8Km/U8PFAPVZX9cHQ3i4NfSZu+L8KLtakFdHWozHIDBiJy9mlHTe3
         lflB5ONIgDlIvcPjqb0X0pW49IZPXTe0v7FKc=
Date: Sun, 15 Nov 2009 03:21:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Message-ID: <20091115022135.GA5427@nowhere>
References: <20091112073909.GB31719@elte.hu> <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp> <20091113105126.GC5243@nowhere> <20091115.102011.227780670.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091115.102011.227780670.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 15, 2009 at 10:20:11AM +0900, Hitoshi Mitake wrote:
> > Thanks :)
> > I haven't started it yet, because of some other things I need to finish.
> > 
> > Would you be interested in starting it?
> 
> Yes, I'm very interested in it!



Great!

 
> > Such a tool would be very useful to profile the kernel locking.
> > 
> > It would be nice to use design close to what perf sched does:
> > having an lock event structure that provides callbacks for each
> > lock events so that we can easily plug various plugin inside.
> > 
> > It's just a suggestion in case you are interested and have time
> > for that. Otherwise I'll do it later.
> > 
> > Hm?
> 
> I'd like to do that.
> But I'm an only newbie, so it may take a week (or more).


Don't worry about that. Take your time.


> So If you finish this work, please post and disregard me :)


No if you take it I won't start a concurrent work.

Don't hesitate if you have questions. This will be the first tool
(at least that I'm aware of) that post-processes the lock
event so you may encounter weird things, missing events,
unappropriate sequences, or any bad things we haven't yet seen.

And don't forget to use -M on perf record to record
the lock events so that you have them multiplexed across cpus
and hence well ordered wrt time. If later we need something that
scales better, we can still drop the use of -M and do the reordering
from userspace.

Thanks.

