Return-Path: <linux-kernel-owner+w=401wt.eu-S1763377AbYBMBPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377AbYBMBPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYBMBPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:15:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56919
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbYBMBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:15:32 -0500
Date: Tue, 12 Feb 2008 17:16:03 -0800 (PST)
Message-Id: <20080212.171603.14132226.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: jeff@garzik.org, arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212163742.c9e778e6.akpm@linux-foundation.org>
References: <47B1CB08.4020101@garzik.org>
	<20080212.155853.193190548.davem@davemloft.net>
	<20080212163742.c9e778e6.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Feb 2008 16:37:42 -0800

> Well there's a case in point.  rcupdate.h is not a part of networking, and
> it is random tree-wandering like this which causes me problems and which
> will cause Stephen problems.
> 
> Now, I don't know which tree "owns" rcupdate.h but it ain't networking. 
> Probably git-sched.
> 
> Nothing in networking depends upon that change (which has a typo in the
> comment, btw) hence it can and should have gone through
> whichever-tree-owns-that-file.
> 
> For Stephen's sake: please.

At least thie time I did make sure that change got posted to
linux-kernel and got properly reviewed by the de-facto maintainer
(Paul McKenney). :-)

I'll toss it.

But how do I do that using GIT without rebasing and without
having this ugly changeset and revert in there?

That's the thing I want answered, and although Al claims it does,
git cherry-pick does not seem to do what I want either.

