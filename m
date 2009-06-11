Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbZFKSwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbZFKSwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbZFKSv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:51:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39732 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbZFKSv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:51:58 -0400
Date: Thu, 11 Jun 2009 20:52:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
Message-ID: <20090611185200.GZ11363@kernel.dk>
References: <20090611111339.GQ11363@kernel.dk> <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain> <20090611182657.GY11363@kernel.dk> <alpine.LFD.2.01.0906111134180.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111134180.3573@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11 2009, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Jun 2009, Jens Axboe wrote:
> > 
> > > Btw, Jens: in your tree, you've committed Tejun's changes without adding 
> > > your own sign-off. Not good!
> > 
> > That's for the patches that I pulled from his git tree. It should list
> > him as committer too.
> 
> NO!
> 
> It sounds like you have done a _major_ no-no, which is to pull from his 
> tree, and then rebase it. 
> 
> DO NOT DO THAT! NOT EVER!
> 
> If you pull from somebody elses tree, you can no longer touch the commit. 
> It absolutely has to stay the same. Otherwise we see this kind of insane 
> duplication. 
> 
> You're doing something seriously wrong here. I wrote a long rant about 
> what the rules were last release cycle, but now I can't find it. 
> Basically, if you're not the committer, you really must never EVER touch 
> it. 
> 
> [ Anybody with enough google-fu to find my rant, so I don't have to 
>   re-rant? ]

I pulled from his tree, don't think I ever rebased it. To be honest, I
rebase a lot, and I used to do that for the 'export' branches as well.
But for this cycle I have kept it clean and pulled in your tree when I
knew a conflict at arisen. More trees are now based off the block tree,
so I wanted to make sure that they were able to pull cleanly when they
wanted to. I usually also always apply the patches manually instead of
pulling it in, since I go over the patches anyway.

So I fully agree with what you are saying, if anything was rebased this
time then it was a mistake (that I don't recollect)...

-- 
Jens Axboe

