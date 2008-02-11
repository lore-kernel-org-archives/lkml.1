Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbYBKOft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbYBKOft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYBKOfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:35:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbYBKOfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:35:08 -0500
Date: Mon, 11 Feb 2008 22:31:14 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH] proc: extend /proc/<pid>/fdinfo/<fd>
Message-ID: <20080211143114.GB3695@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20080209120157.GA3035@kernel.sg> <2f11576a0802110220g459d7390je05bfec161e6768e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0802110220g459d7390je05bfec161e6768e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Motohiro-san,

<quote sender="KOSAKI Motohiro">
> In general, I think this patch isn't wrong idea.
> but it shuld be brush up more, may be.

Thanks.

> > kerndev: ~/code/kernel# cat /proc/`pgrep pickup`/fdinfo/6
> > mode:   0622
> 
> I think this is inode attribute, but not fd attribute.

Yes, it is an inode attribute.

> > dev:    253,0
> > ino:    21463057
> 
> may be useful, agreed with you :)

Thanks.

> > uid:    89
> > gid:    89
> > rdev:   0,0
> > pos:    0
> > flags:  04002 FD_CLOEXEC # if close-on-exec flag is set
> 
> agreed with Miklos's opinion.
> 
> > path:   /var/spool/postfix/public/pickup
> 
> may be, we shold think namespace..

Besides readlink, this info can be gathered by running:
ls -laF /proc/<pid>/fd/<fd>

So, I agree with Miklo's opinion that we can omit this in the output.

> > You can also use this to find out more information about locked open files:
> 
> is your requirement only fd -> ino pick up?

Not only this, but it is useful to know quickly if the open file descriptor
has a close-on-exec flag set.

Thanks,
Eugene
