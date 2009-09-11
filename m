Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbZIKF4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbZIKF4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZIKF4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:56:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51175 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZIKF4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:56:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [GIT PULL] please pull ummunotify
Cc: kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jsquyres@cisco.com,
       linux-rdma@vger.kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <aday6omhz9d.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com>
Message-Id: <20090911145036.DB65.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 11 Sep 2009 14:56:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

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

I'm sorry. I haven't review this code and I didn't track this discussion
carefully. but I have one stupid question. May I ask? 
Can I this version already solved fork() + COW issue? if so, could you
please explain what happen at fork. Obviously RDMA point to either parent
or child page, not both. but Corrent COW rule is, first touch process
get copyed page and other process still own original page. I think it's 
unpecected behavior form RDMA.


