Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZDUJ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZDUJ7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZDUJ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:58:54 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46142 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZDUJ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=beOkvFB+p4G43wHqblWPrvBqLuadA7h/W22Zs+72sP4MpiszbvlQ7+jwyIfd6QfOh2
         kPygDjI0z4dnytSK36nG/rcB6LW09hhPr/KMvuv1NQunZFHdzAY6iklqDbOCJ+hYv/zH
         CnoF4vNqV+ykRFvj2fs+3C9CaJbRbe6bEgwxY=
Date: Tue, 21 Apr 2009 11:58:49 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] cgroup: io-throttle controller (v14)
Message-ID: <20090421095848.GB13699@linux>
References: <1240090636-898-1-git-send-email-righi.andrea@gmail.com> <49EC34C1.6010709@cn.fujitsu.com> <20090420144816.GA13307@linux> <49ED1E66.6030604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ED1E66.6030604@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:16:22AM +0800, Gui Jianfeng wrote:
> Andrea Righi wrote:
> > On Mon, Apr 20, 2009 at 04:39:29PM +0800, Gui Jianfeng wrote:
> >> Andrea Righi wrote:
> >> ...
> >>> Implementation
> >>> ~~~~~~~~~~~~~~
> >>> Patchset against latest Linus' git:
> >>>
> >>>   [PATCH 0/7] cgroup: block device IO controller (v14)
> >>>   [PATCH 1/7] io-throttle documentation
> >>>   [PATCH 2/7] res_counter: introduce ratelimiting attributes
> >>>   [PATCH 3/7] page_cgroup: provide a generic page tracking infrastructure
> >>>   [PATCH 4/7] io-throttle controller infrastructure
> >>>   [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
> >>>   [PATCH 6/7] io-throttle instrumentation
> >>>   [PATCH 7/7] export per-task io-throttle statistics to userspace
> >>   Hi Andrea,
> >>
> >>   I'd like to have a try this patchset, would you tell what's the kernel version
> >>   and bio-cgroup version based on?
> >>
> > 
> > Latest Linus' git is the kernel and bio-cgroup v7 (from
> > http://people.valinux.co.jp/~ryov/bio-cgroup/).
> 
>   Sorry, I still can't apply it...
> 
> [root@localhost linux-2.6.30-rc1]# patch -p1 --dry-run < ../cgroup-io-throttle-v14.patch                                                                                         patching file Documentation/cgroups/io-throttle.txt
> patching file block/Makefile
> patching file block/blk-core.c
> patching file block/blk-io-throttle.c
> patching file block/kiothrottled.c
> patching file fs/aio.c
> patching file fs/buffer.c
> Hunk #1 FAILED at 36.
> Hunk #2 FAILED at 669.
> 2 out of 2 hunks FAILED -- saving rejects to file fs/buffer.c.rej
> patching file fs/proc/base.c
> patching file include/linux/blk-io-throttle.h
> patching file include/linux/cgroup_subsys.h
> Hunk #1 succeeded at 49 (offset 6 lines).
> patching file include/linux/memcontrol.h
> Reversed (or previously applied) patch detected!  Assume -R? [n] n
> Apply anyway? [n] n
> Skipping patch.
> 2 out of 2 hunks ignored -- saving rejects to file include/linux/memcontrol.h.rej
> patching file include/linux/mmzone.h
> Hunk #1 FAILED at 607.
> Hunk #2 FAILED at 958.
> ...

Could you checkout the latest Linus' git?

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6

Or at least try with 2.6.30-rc2. It should apply cleanly also to this
version.

-Andrea
