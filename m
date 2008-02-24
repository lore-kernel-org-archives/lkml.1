Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYCBKP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYCBKP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 05:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYCBKPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 05:15:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2465 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753025AbYCBKPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 05:15:13 -0500
Date: Sun, 24 Feb 2008 19:03:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
Message-ID: <20080224180339.GA3861@ucw.cz>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core> <87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228111349.6831925c@core>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > That sounds like a non starter. What if the box is busy, what if the
> > > daemon or something you touch needs memory and causes paging ?
> > 
> > The daemon runs mlock'd anyway, so there won't be any need for paging
> 
> mlock does not guarantee anything of that form. A syscall by an mlocked
> process which causes a memory allocation can cause paging of another
> process on the system.

Well... but you can be careful about the syscalls, right?

Anyway, active protection is 'best effort' anyway. There's not enough
time to park heads if you drop the machine without tilting it first...
and we have been running with no protection for years now...

> > stays in memory all the time, it can go ahead and notify the kernel that
> > the disk heads should be unloaded. The kernel takes care to insert the
> > idle immediate command at the head of the queue. Am I missing something?
> 
> Yes - the fact we may well have bounced off the floor already.

Well, shit happens. Even notebook with parked harddrive is not
guaranteed to survive the fall.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
