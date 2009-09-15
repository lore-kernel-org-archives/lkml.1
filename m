Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZIOLeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZIOLeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZIOLem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:34:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49377 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZIOLel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:34:41 -0400
Date: Tue, 15 Sep 2009 13:34:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jsquyres@cisco.com, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull ummunotify
Message-ID: <20090915113434.GF1328@ucw.cz>
References: <aday6omhz9d.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday6omhz9d.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Linus, please consider pulling from
> 
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
> 
> This tree is also available from kernel.org mirrors at:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
> 
> This will get "ummunotify," a new character device that allows a
> userspace library to register for MMU notifications; this is
> particularly useful for MPI implementions (message passing libraries
> used in HPC) to be able to keep track of what wacky things consumers
> do to their memory mappings.  My colleague Jeff Squyres from the Open
> MPI project posted a blog entry about why MPI wants this:
> 
> http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_memory_tracking/
> 
> His summary of ummunotify:
> 
>   "It???s elegant, doesn???t require strange linker tricks, and seems to
>    work in all cases.  Yay!"
> 
> This code went through several review iterations on lkml and was in
> -mm and -next for quite a few weeks.  Andrew is OK with merging it (I
> think -- Andrew please correct me if I misunderstood you).

I don't remember seeing discussion of this on lkml. Yes it  is in
-next...

Basically it allows app to 'trace itself'? ...with interesting mmap()
interface, exporting int to userspace, hoping it behaves atomically...? 
	
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
