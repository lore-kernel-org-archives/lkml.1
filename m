Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZIQLah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZIQLah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZIQLag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:30:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZIQLag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:30:36 -0400
Subject: Re: [GIT PULL] please pull ummunotify
From: Peter Zijlstra <peterz@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jsquyres@cisco.com, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <aday6omhz9d.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Sep 2009 13:30:28 +0200
Message-Id: <1253187028.8439.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 21:38 -0700, Roland Dreier wrote:
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
>   "It’s elegant, doesn’t require strange linker tricks, and seems to
>    work in all cases.  Yay!"
> 
> This code went through several review iterations on lkml and was in
> -mm and -next for quite a few weeks.  Andrew is OK with merging it (I
> think -- Andrew please correct me if I misunderstood you).

Anton Blanchard suggested a while back that this might be integrated
with perf-counters, since perf-counters already does mmap() tracking and
also provides events through an mmap()'ed buffer.

Has anybody looked into this?

If someone did and I missed the discussion on why it isn't appropriate,
kindly point me in the right direction ;-)


