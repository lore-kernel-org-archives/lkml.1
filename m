Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZEEW1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZEEW1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZEEW0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:26:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:52689 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbZEEW0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:26:50 -0400
From: Neil Brown <neilb@suse.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Date: Wed, 6 May 2009 08:26:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18944.48423.172087.449619@notabene.brown>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 04/16] DRBD: bitmap
In-Reply-To: message from Lars Marowsky-Bree on Tuesday May 5
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-5-git-send-email-philipp.reisner@linbit.com>
	<1241278918.3639.46.camel@mulgrave.int.hansenpartnership.com>
	<20090502172838.GC6466@racke>
	<18941.10725.335758.894491@notabene.brown>
	<20090505174831.GD14192@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 5, lmb@suse.de wrote:
> On 2009-05-03T15:21:41, Neil Brown <neilb@suse.de> wrote:
> 
> > As I said, I don't immediately see the benefits of the activity log
> > format, however,
> >  1/ I am happy to listen to its benefits being explained
> >  2/ If we were to agree that merging DRBD functionality into md
> >    (for which there isn't a concrete proposal, but the suggestion
> >     seems to be floating around) were a good thing, I don't have any
> >     problem with supporting an activity log in md in the name of
> >     compatibility.
> 
> So, let's take a step back here.
> 
> All of this is extremely beneficial discussion to be had. As some of you
> are (painfully, sometimes ;-) aware, I'm a big fan of converging RAID
> implementations/back-ends, and the goal is well received.
> 
> But this will take a while, and both drbd, md, md/nbd, or even dm-raid1
> have large existing user bases, and HA environments don't switch easily.
> All are actively maintained.
> 
> Sharing more and more of the code strikes me as a mid-term goal, and
> full converges as a long-term one (alas).
> 
> What I think this argument has shown that drbd's design is sound (even
> if some choices, like that of the alternatives, are up for discussion),
> similar to different file systems (of which we seem to have plenty
> too).
> 
> I would suggest at this time, we may want to refocus on the remaining
> objections to merging drbd as a driver in the short-term.

I cannot imagine that there would be any.  Given its history, its
popularity, and its modularity, there can be no question about merging
it, and only a possible question on whether it should spend some time
in 'staging' first.
I doubt there is much call for that, but nor it is clear to be how the
decision would be made.

> 
> I think I've not read anything in the last 3-5 days which still would
> rate as a reason for rejection or delay.
> 
> Did I miss something?

This is lkml - no one can catch everything :-)

I big part of why I was comparing and contrasting DRBD to md is
because that enables me to understand it better.  That sort of in-depth
understanding is, for me, a prerequisite for an in-depth review.

So it is all just part of the review process....

NeilBrown
