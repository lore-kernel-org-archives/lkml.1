Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbYBUVCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbYBUVCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764394AbYBUVCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:02:13 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54386 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762167AbYBUVCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:02:11 -0500
Date: Thu, 21 Feb 2008 23:01:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Roland Dreier <rdreier@cisco.com>, Linus Torvalds <torvalds@osdl.org>
Cc: Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Merging of completely unreviewed drivers
Message-ID: <20080221210124.GD28328@cs181133002.pp.htv.fi>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adahcg2awag.fsf@cisco.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Linus Added to the To: since I want to hear his opinion on this issue. ]

On Thu, Feb 21, 2008 at 12:28:55PM -0800, Roland Dreier wrote:
>  > This driver should really have gotten some review before being included 
>  > in the kernel.
> 
>  > Even a simple checkpatch run finds more than > 250 stylistic errors
>  > (not code bugs but cases where the driver violates the standard code 
>  > formatting rules of kernel code).
> 
> Linus has strongly stated that we should merge hardware drivers early,
> and I agree: although the nes driver clearly needs more work, there's
> no advantage to users with the hardware in forcing them to wait for
> 2.6.26 to merge the driver, since they'll just have to patch the
> grungy code in themselves anyway.  And by merging the driver early, we
> get fixed up for any tree-wide changes and allow janitors to help with
> the cleanup.

Is it really intended to merge drivers without _any_ kind of review?

This driver even lacks a basic "please fix the > 250 checkpatch errors" [1]
and similar low hanging fruits that could easily be spotted and then 
fixed by the submitter within a short amount of time.

I see the point that it might make sense to not prevent the merging of 
drivers infinitely when they have some hard-to-fix issues, but was this 
really meant as an excuse for maintainers to no longer any review of 
what they merge at all?

> (By the way, the code is not that pretty but it a lot closer to
> upstream style than most driver submissions)
>...

There might be worse code being submitted, but when looking at what gets 
merged into Linus' tree this driver beats all other drivers I remember 
in both number of stylistic problems and bugs. [2]

>  - R.

cu
Adrian

BTW: Greg, you are Cc'ed for your joke in [3]...

[1] not to mention the > 2000 checkpatch warnings
[2] as already said, that's not meant against the driver submitter
    I'm complaining about the complete lack of review that would have 
    brought this driver into shape
[3] http://lkml.org/lkml/2008/2/12/427

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

