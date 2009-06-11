Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZFKSo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZFKSo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZFKSoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:44:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbZFKSn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:43:58 -0400
Date: Thu, 11 Jun 2009 11:42:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Tejun Heo <tj@kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first block round for 2.6.31
In-Reply-To: <20090611182657.GY11363@kernel.dk>
Message-ID: <alpine.LFD.2.01.0906111134180.3573@localhost.localdomain>
References: <20090611111339.GQ11363@kernel.dk> <alpine.LFD.2.01.0906111105021.3573@localhost.localdomain> <20090611182657.GY11363@kernel.dk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Jens Axboe wrote:
> 
> > Btw, Jens: in your tree, you've committed Tejun's changes without adding 
> > your own sign-off. Not good!
> 
> That's for the patches that I pulled from his git tree. It should list
> him as committer too.

NO!

It sounds like you have done a _major_ no-no, which is to pull from his 
tree, and then rebase it. 

DO NOT DO THAT! NOT EVER!

If you pull from somebody elses tree, you can no longer touch the commit. 
It absolutely has to stay the same. Otherwise we see this kind of insane 
duplication. 

You're doing something seriously wrong here. I wrote a long rant about 
what the rules were last release cycle, but now I can't find it. 
Basically, if you're not the committer, you really must never EVER touch 
it. 

[ Anybody with enough google-fu to find my rant, so I don't have to 
  re-rant? ]

		Linus
