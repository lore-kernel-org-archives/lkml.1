Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYK1QTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYK1QTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYK1QTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:19:20 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35712 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYK1QTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:19:19 -0500
Date: Fri, 28 Nov 2008 21:49:21 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, jblunck@suse.de, dlezcano@fr.ibm.com,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [rfc git patch] union directory
Message-ID: <20081128161921.GA3843@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 12:01:32PM +0100, Miklos Szeredi wrote:
> I've been doing some small fixing/cleanup work on the union directory
> patches by Jan, and just noticed there's a thread about the union
> mounts on LKML, so I thought publicizing won't hurt.

Interesting that you call it "union directory", do you have plans to go
the Plan 9's way of union directories ?

> 
> It's still a work in progress, notably the readdir code currently only
> works on a few specific filesystem types.

readdir was one of the things on which we couldn't reach a consensus
on how to do it the right way. We were suggested that we move the
duplicate elimination into user space and an effort towards this was
also done (Ref: http://lkml.org/lkml/2008/4/29/248) by moving this
to glibc readdir. But we weren't sure how this could work for NFS and
were told that it is required to get the NFS side of things
sorted out first. So that's where readdir effort stands now afaik.
Do you have any ideas/plans on this front ?

Also the last development activity that I am aware of was done towards
getting a generic whiteout support. David Woodhouse started a git tree
at one point of time for whiteout support
(git://git.infradead.org/union/whiteout-2.6.git). Erez Zodak was
infact looking forward for these changes to make use of them in Unionfs,
but even this effort died down.

Nice to know that you have started looking into Union Mount patches.
Would be interesting to know/understand your plans/thoughts on taking
this effort forward.

Regards,
Bharata.
