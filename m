Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYGXISh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYGXISh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 04:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYGXISY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 04:18:24 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1610 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYGXISX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 04:18:23 -0400
Date: Thu, 24 Jul 2008 10:18:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] MMC updates for 2.6.27-rc1
Message-ID: <20080724081820.GH20055@kernel.dk>
References: <20080719015911.02faddf6@mjolnir.drzeus.cx> <20080723150031.36e5b85a@mjolnir.drzeus.cx> <alpine.LFD.1.10.0807231206230.4754@woody.linux-foundation.org> <20080723234350.3acad60d@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723234350.3acad60d@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23 2008, Pierre Ossman wrote:
> On Wed, 23 Jul 2008 12:08:01 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Wed, 23 Jul 2008, Pierre Ossman wrote:
> > >
> > >  include/linux/scatterlist.h |   38 +++++++
> > >  lib/scatterlist.c           |  176 +++++++++++++++++++++++++---------
> > > 
> > > Tejun Heo (1):
> > >       sg: reimplement sg mapping iterator
> > 
> > I'd really have been a lot happier about this one if it had had a few 
> > Acked-by's from people like Jens and James.
> > 
> > But I pulled, and pushed out. I think Jens is on vacation, but I'm adding 
> > him to the cc anyway.
> 
> Yeah, I was hoping to get Jens' input on this aswell, but this fixes
> problems in the sdhci driver so it was pushed in the hope that he won't
> NAK it too badly when he gets back.
> 
> (James just got casually poked, but I wasn't even aware he was a
> suitable person for this. lib/ and kernel/ are generally a bit
> problematic when it comes to determining maintainer :/)

(still pretty much off line, though not completely without internet
anymore :-)

The scatterlist iter commit looks sane to me. It's too late for an ack,
but I have reviewed it now.

-- 
Jens Axboe

