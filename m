Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbZIRUoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbZIRUoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbZIRUoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:44:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40747 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbZIRUoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:44:06 -0400
Date: Fri, 18 Sep 2009 22:44:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090918204409.GV23126@kernel.dk>
References: <20090917194027.GS23126@kernel.dk> <1253229410.2783.16.camel@heimdal.trondhjem.org> <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk> <1253290790.3183.14.camel@heimdal.trondhjem.org> <20090918173608.GD23126@kernel.dk> <20090918183203.GG23126@kernel.dk> <1253305003.10538.72.camel@laptop> <20090918202245.GR23126@kernel.dk> <1253306306.10538.80.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253306306.10538.80.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009, Peter Zijlstra wrote:
> On Fri, 2009-09-18 at 22:22 +0200, Jens Axboe wrote:
> > On Fri, Sep 18 2009, Peter Zijlstra wrote:
> > > On Fri, 2009-09-18 at 20:32 +0200, Jens Axboe wrote:
> > > > Peter, if you have
> > > > the time, it would be nice if you could check whether this one works for
> > > > you too.
> > > 
> > > Doesn't make my machine happy :/
> > 
> > That looks like a double register. Irk, I see what it is... Can you try
> > this additional patch?
> 
> Still deeply unhappy,..
> 
> 1) double bdi registation
> 2) lockdep splat on bdi registration
> 3) NULL ptr deref on netfs automount
> 
> Also note the lockdep splat which I think is caused by these patches..

Sigh, I guess no love for me tonight. OK thanks for testing Peter, I
guess a real tested fix will have to wait for me to get behind the test
box.

-- 
Jens Axboe

