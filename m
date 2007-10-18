Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXJRMju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXJRMju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761688AbXJRMjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:39:41 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19879 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763735AbXJRMjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:39:40 -0400
Date: Thu, 18 Oct 2007 14:39:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018123902.GD5063@kernel.dk>
References: <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <20071018.053636.21618957.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018.053636.21618957.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, 18 Oct 2007 14:15:47 +0200
> 
> > On Thu, Oct 18 2007, Jens Axboe wrote:
> > > On Thu, Oct 18 2007, David Miller wrote:
> > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > Date: Thu, 18 Oct 2007 13:57:02 +0200
> > > > 
> > > > > Thanks a lot, Dave! The patch is a monster right now, I'll work on
> > > > > splitting it into a 3-step process. Any arch help is greatly
> > > > > appreciated.
> > > > 
> > > > I have some other bits that my compile hit, such as some things in the
> > > > crypto layer.
> > > 
> > > Yeah, I have tons of that so far. I hope to have an allyesconfig
> > > compiling pretty soonish, will send that out then.
> > 
> > OK here goes, this compiles with allyesconfig on x86-64. Not too bad,
> > the scsi/ drivers were by far the worst.
> 
> It build cleanly here on sparc64 too.

Super

> It's late and I'm about to hit bed so I'm too chicken to do a test
> boot it right now :-)

Don't boot it Dave, odds are that something will break and you'll then
be stuck debugging that since you can't relax and sleep until it's
working :-)

-- 
Jens Axboe

