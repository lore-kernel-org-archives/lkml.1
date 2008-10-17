Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYJQNiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYJQNiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYJQNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:38:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56801 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYJQNii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:38:38 -0400
Date: Fri, 17 Oct 2008 15:37:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [BUG] linux-next: Tree for October 16 - softlockup detected at blk_invoke_request_fn
Message-ID: <20081017133750.GL19428@kernel.dk>
References: <20081016211811.a523c8f2.sfr@canb.auug.org.au> <20081016204212.GC7534@linux.vnet.ibm.com> <20081017065558.GD19428@kernel.dk> <20081017102456.GA8115@linux.vnet.ibm.com> <20081017105753.GG19428@kernel.dk> <20081018001533.06ec0d1b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018001533.06ec0d1b.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18 2008, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Fri, 17 Oct 2008 12:57:55 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > OK, I'm guessing it's a merge mess in linux-next. I tried to look at the
> > diff, but it was pretty much impossible to read and even included lots
> > of things in -git already.
> 
> If you are looking at the linux-next patch on kernel.org, then it is
> relative to 2.6.27, so will contain a lot of stuff in Linus' tree.  Its
> purpose is to allow people to recreate the linux-next tree from a kernel
> tarball.
> 
> In the linux-next git tree, the point in Linus' tree that it is based on
> the the "stable" branch.  If necessary, people should be able to bisect
> between the "stabel" and "master" branches of a linux-next tree.  Or, I
> am told, between one linux-next tree and another (but that sounds painful
> to me).

OK, I'll try the -git tree next time I have to lookup changes in -next.
Thanks for the explanation!

-- 
Jens Axboe

