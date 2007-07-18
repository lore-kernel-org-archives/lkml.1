Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXGRW6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXGRW6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbXGRW5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:57:39 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42908 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503AbXGRW5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:57:38 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, andros@citi.umich.edu
Subject: Re: [PATCH 000 of 20] knfsd: Support 'secinfo' exports with related cleanups
Date: Wed, 18 Jul 2007 18:57:25 -0400
Message-Id: <11847994502579-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <20070713114228.3c171a90.akpm@linux-foundation.org>
References: <20070713114228.3c171a90.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Jul 2007 11:42:28 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 13 Jul 2007 14:10:25 -0400 "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > On Fri, Jul 13, 2007 at 12:33:10AM -0700, Andrew Morton wrote:
> > > Please consider feeding knfsd patches through checkpatch in the
> > > future.  It did find several glitches in these patches which you
> > > might have chosen to address.
> >
> > OK.  I guess I'll wait till the next -mm is out, take a look, and
> > address your comments then.
>
> I probably won't get another -mm out until after the 2.6.23 merge window
> closes.  One reason for this is all the extra time which I need to
> devote to code-review, hint.
> 
> But I don't think there was anything which I identified in this nfsd
> batch which needs attention prior to a 2.6.23-rc1 merge.  The checkpatch
> stuff is more a "please do this next time" thing.

OK, so the following address the review comments.

The first two should really be applied before -rc1 if at all possible:

	- the first is a preexisting bug stumbled on while doing this
	  work, also suitable for stable.
	- the second is a fix for a regression introduced by my patches.
	  (Apologies!)

(The other three patches, as you say, can wait till after rc1.)

--b.
