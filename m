Return-Path: <linux-kernel-owner+w=401wt.eu-S1765161AbYFHMoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765161AbYFHMoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYFHMoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:44:23 -0400
Received: from 1wt.eu ([62.212.114.60]:1585 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbYFHMoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:44:22 -0400
Date: Sun, 8 Jun 2008 14:29:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Missing patch from stable [3/7]
Message-ID: <20080608122920.GA10491@1wt.eu>
References: <20080608085923.GC6439@1wt.eu> <1212923462.4020.224.camel@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212923462.4020.224.camel@tucsk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 01:11:02PM +0200, Miklos Szeredi wrote:
> 
> On Sun, 2008-06-08 at 10:59 +0200, Willy Tarreau wrote:
> > this patch from mainline seems suitable for -stable,
> 
> Willy,
> 
> Thanks for picking up these ecryptfs patches ...but they hardly meet
> _any_ of the -stable rules.  In particular:
> 
> 
>  - It must be obviously correct and tested.
> 
> It's obvious, but I don't know if it's been tested (or even looked at by
> the maintainer).

well, some of them (eg: Cyrill's fix for missed mutex_unlock) are obviously
needed.

>  - It cannot be bigger than 100 lines, with context.
> 
> Check.
> 
>  - It must fix only one thing.
> 
> No, it's a small fix as well as a cleanup.
> 
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
> 
> No, it doesn't seem to bother anybody.

Generally speaking, everything which relates to locking is hard to diagnose.
I've been hit for years by locking bugs in the NFS client on old 2.4, and
they hit me at most once in a week.

>  - It must fix a problem that causes a build error (but not for things
>    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
>    security issue, or some "oh, that's not good" issue.  In short, something
>    critical.
> 
> Not critical at all.

OK

>  - No "theoretical race condition" issues, unless an explanation of how the
>    race can be exploited is also provided.
> 
> It's theoretical, I have no idea how it's exploitable, if at all.

OK, but being exploitable is one thing, randomly failing is another one. If
you think it cannot cause trouble, then OK.

>  - It cannot contain any "trivial" fixes in it (spelling changes,
>    whitespace cleanups, etc).
> 
> Check.
> 
>  - It must follow the Documentation/SubmittingPatches rules.
> 
> Check.
> 
>  - It or an equivalent fix must already exist in Linus' tree.  Quote the
>    respective commit ID in Linus' tree in your patch submission to -stable.
> 
> Check.
> 
> 
> Total: 4/9, not a very convincing score :)

Well, you know the implications of leaving these known bugs open more than
me. If you think some of them are really not needed, I'm fine with this,
but some definitely fix real bugs (judging by the code and the comments).

Thanks,
Willy

