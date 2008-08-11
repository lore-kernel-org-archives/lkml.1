Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbYHKJIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbYHKJIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYHKJIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:08:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:59041 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYHKJIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:08:46 -0400
Date: Mon, 11 Aug 2008 18:07:15 +0900
To: drzeus-list@drzeus.cx
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Subject: Re: [GIT PULL] MMC updates for 2.6.27-rc1
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080723234350.3acad60d@mjolnir.drzeus.cx>
References: <20080723150031.36e5b85a@mjolnir.drzeus.cx>
	<alpine.LFD.1.10.0807231206230.4754@woody.linux-foundation.org>
	<20080723234350.3acad60d@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080811180722Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 23:43:50 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

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

I think that you can see that James pushed the old sg buffer helper
functions from the git log (because it was invented for SCSI drivers).

Anyway, the new helper functions look fine though I'm too late for
reviewing it.
