Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbZCZJ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbZCZJ7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZCZJ72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:59:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53546 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166AbZCZJ71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:59:27 -0400
Date: Thu, 26 Mar 2009 10:59:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: zdenek.kabelac@gmail.com, bunk@kernel.org, jirislaby@gmail.com,
       hidave.darkstar@gmail.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, nikanth@gmail.com
Subject: Re: [PATCH] Fix Bug 10504 - losetup possible circular locking
Message-ID: <20090326095924.GP27476@kernel.dk>
References: <200903121341.13173.knikanth@suse.de> <200903261512.22775.knikanth@suse.de> <20090326094847.GN27476@kernel.dk> <200903261522.57041.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903261522.57041.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26 2009, Nikanth Karthikesan wrote:
> On Thursday 26 March 2009 15:18:47 Jens Axboe wrote:
> > On Thu, Mar 26 2009, Nikanth Karthikesan wrote:
> > > On Tuesday 24 March 2009 17:00:32 Jens Axboe wrote:
> > > > On Tue, Mar 24 2009, Nikanth Karthikesan wrote:
> > > > > Hi Jens
> > > > >
> > > > > Did you get to look at this? Can you ACK/NACK this one?
> > > >
> > > > It looks fine, I have applied it.
> > >
> > > Thanks. But it looks like, the patch I quoted in the changelog had the
> > > "---" delimiter, which made you commit without the full changelog and
> > > signed-off. Sorry for that mistake.
> >
> > That was actually done on purpose, I wanted the whole thing there! It
> > was a lot more useful than the short summary. Never be afraid to write
> > exhaustive changelogs, I even put the test app in there for some cases
> > when that makes sense.
> 
> Yes, but because of a delimiter '---' in my changelog, the git log has only 
> half of the changelog. IOW, the whole thing is not there.

Hmm right, it does appear to be missing everything from (and including)
the

--- a/drivers/block/loop.c

part. I'll fix it up, thanks for noticing!

-- 
Jens Axboe

