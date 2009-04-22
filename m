Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZDVMno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZDVMno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZDVMnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:43:35 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58190 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZDVMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dy80jkoMOvxzxd3UlI+CG1zPKSaskjKGfoE0Goy7IOraErReTe1vVEy15VC+N7hUG2
         N9JCCGFCOG6Q8Ex8EdNbPtKBVXolwac6ixYbuDmU6lJZrXrS52VnVWTOrq6dJAFApJlC
         Ei1m3Rp77hxx4SFGabhRgTsgZ+h58bFu9BkB4=
Date: Wed, 22 Apr 2009 14:43:29 +0200
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
Message-ID: <20090422124328.GA32007@linux>
References: <1240090636-898-1-git-send-email-righi.andrea@gmail.com> <49EC34C1.6010709@cn.fujitsu.com> <20090420144816.GA13307@linux> <49ED1E66.6030604@cn.fujitsu.com> <20090421095848.GB13699@linux> <49EE6E3C.8050409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE6E3C.8050409@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 09:09:16AM +0800, Gui Jianfeng wrote:
> Andrea Righi wrote:
> > On Tue, Apr 21, 2009 at 09:16:22AM +0800, Gui Jianfeng wrote:
> >> Andrea Righi wrote:
> >>> On Mon, Apr 20, 2009 at 04:39:29PM +0800, Gui Jianfeng wrote:
> >>>> Andrea Righi wrote:
> >>>> ...
> >>>>> Implementation
> >>>>> ~~~~~~~~~~~~~~
> >>>>> Patchset against latest Linus' git:
> >>>>>
> >>>>>   [PATCH 0/7] cgroup: block device IO controller (v14)
> >>>>>   [PATCH 1/7] io-throttle documentation
> >>>>>   [PATCH 2/7] res_counter: introduce ratelimiting attributes
> >>>>>   [PATCH 3/7] page_cgroup: provide a generic page tracking infrastructure
> >>>>>   [PATCH 4/7] io-throttle controller infrastructure
> >>>>>   [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
> >>>>>   [PATCH 6/7] io-throttle instrumentation
> >>>>>   [PATCH 7/7] export per-task io-throttle statistics to userspace
> >>>>   Hi Andrea,
> >>>>
> >>>>   I'd like to have a try this patchset, would you tell what's the kernel version
> >>>>   and bio-cgroup version based on?
> >>>>
> >>> Latest Linus' git is the kernel and bio-cgroup v7 (from
> >>> http://people.valinux.co.jp/~ryov/bio-cgroup/).
> >>   Sorry, I still can't apply it...
> >>
> >> [root@localhost linux-2.6.30-rc1]# patch -p1 --dry-run < ../cgroup-io-throttle-v14.patch                                                                                         patching file Documentation/cgroups/io-throttle.txt
> >> patching file block/Makefile
> >> patching file block/blk-core.c
> >> patching file block/blk-io-throttle.c
> >> patching file block/kiothrottled.c
> >> patching file fs/aio.c
> >> patching file fs/buffer.c
> >> Hunk #1 FAILED at 36.
> >> Hunk #2 FAILED at 669.
> >> 2 out of 2 hunks FAILED -- saving rejects to file fs/buffer.c.rej
> >> patching file fs/proc/base.c
> >> patching file include/linux/blk-io-throttle.h
> >> patching file include/linux/cgroup_subsys.h
> >> Hunk #1 succeeded at 49 (offset 6 lines).
> >> patching file include/linux/memcontrol.h
> >> Reversed (or previously applied) patch detected!  Assume -R? [n] n
> >> Apply anyway? [n] n
> >> Skipping patch.
> >> 2 out of 2 hunks ignored -- saving rejects to file include/linux/memcontrol.h.rej
> >> patching file include/linux/mmzone.h
> >> Hunk #1 FAILED at 607.
> >> Hunk #2 FAILED at 958.
> >> ...
> > 
> > Could you checkout the latest Linus' git?
> > 
> > $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
> > 
> > Or at least try with 2.6.30-rc2. It should apply cleanly also to this
> > version.
> 
>   Yes, I tried them all, but didn't work. :(
>   Would you try "cgroup-io-throttle-v14.patch" too?

It works for me:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
$ cd linux-2.6
$ wget http://download.systemimager.org/~arighi/linux/patches/io-throttle/cgroup-io-throttle-v14.patch
$ git apply cgroup-io-throttle-v14.patch
(no error reported)

The same for v13.

-Andrea
