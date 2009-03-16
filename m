Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZCPH6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZCPH6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZCPH54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:57:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34720 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZCPH54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:57:56 -0400
Date: Mon, 16 Mar 2009 08:57:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] block: cleanup patches
Message-ID: <20090316075752.GK27476@kernel.dk>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <49BB0FB7.2070109@kernel.org> <20090315164526.GD27476@kernel.dk> <49BDA842.1090208@kernel.org> <20090316072211.GI27476@kernel.dk> <49BE0570.6000907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BE0570.6000907@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16 2009, Tejun Heo wrote:
> Jens Axboe wrote:
> > On Mon, Mar 16 2009, Tejun Heo wrote:
> >> Jens Axboe wrote:
> >>> On Sat, Mar 14 2009, Tejun Heo wrote:
> >>>> Tejun Heo wrote:
> >>>>> Hello,
> >>>>>
> >>>>> This patchset is available in the following git tree.
> >>>>>
> >>>>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup
> >>>>>
> >>>>> This patchset contains the following 14 cleanup patches.
> >>>> Jens, once you're okay with the rest of the changes, I'll remove IDE
> >>>> related stuff and repost the patchset.
> >>> I only gave it a quick glance, looks mostly OK. Though I don't like
> >>> putting elv_ prefixed stuff in blk-core. I agree it belongs there
> >>> though, it's really block layer functionality and not io scheduler
> >>> interfacing. So rename it blk_ instead and put compatability names in
> >>> the header file instead.
> >> Yeap, that exactly is what's planned (the peek/fetch patches :-).
> > 
> > I figured that is where it's going :-)
> > How far along with that are you? We are getting really close to the
> > merge window, so it basically has to be ready _now_ to hit 2.6.30.
> 
> The peek/fetch patchset is almost ready.  They just need to be
> refreshed for for-2.6.30.  I'm currently trying to clean up rq->data,
> ->buffer and data length handling and was thinking about putting
> peek/fetch patchset on top of those, which I don't think will be ready
> soon enough for 2.6.30 merge window.  Given the nature of these
> patches, I think we can wait for 31 window?

Yeah, lets hold those off for 2.6.31. We definitely want plenty of time
to review and test such patches.

-- 
Jens Axboe

