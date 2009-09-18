Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZIRUB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZIRUB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZIRUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:01:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46011 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZIRUBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:01:54 -0400
Date: Fri, 18 Sep 2009 22:01:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090918200157.GK23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk> <20090917194027.GS23126@kernel.dk> <1253229410.2783.16.camel@heimdal.trondhjem.org> <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk> <1253290790.3183.14.camel@heimdal.trondhjem.org> <20090918173608.GD23126@kernel.dk> <20090918183203.GG23126@kernel.dk> <1253299218.3183.84.camel@heimdal.trondhjem.org> <20090918184602.GJ23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918184602.GJ23126@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009, Jens Axboe wrote:
> On Fri, Sep 18 2009, Trond Myklebust wrote:
> > On Fri, 2009-09-18 at 20:32 +0200, Jens Axboe wrote:
> > > How does this look? It compiles, but I cannot test before sunday. It
> > > would be great if you (or someone else) could :-). Peter, if you have
> > > the time, it would be nice if you could check whether this one works for
> > > you too.
> > > 
> > > diffstat is tasty, too:
> > > 
> > >  client.c |    4 ----
> > >  super.c  |   53 ++++++++++++++++++++++++++---------------------------
> > >  2 files changed, 26 insertions(+), 31 deletions(-)
> > 
> > Yep! The patch looks good to me. I'll see if I can find the time to test
> > it tomorrow.
> 
> Thanks a lot! I'll try nfs over wifi on the laptop now, since the test
> boxes are off.

Took a little longer than it should have, since latest -git breaks my
iwl3945. Anyway, it works fine for me. The patch is tentatively
committed as:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0841ff4261ae91b01c923be97843753c56a6613a

-- 
Jens Axboe

