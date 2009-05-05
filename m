Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZEERvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZEERvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZEERvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:51:32 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51819 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbZEERvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:51:31 -0400
Subject: Re: [PATCH 04/16] DRBD: bitmap
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Neil Brown <neilb@suse.de>, Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20090505174831.GD14192@suse.de>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-4-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-5-git-send-email-philipp.reisner@linbit.com>
	 <1241278918.3639.46.camel@mulgrave.int.hansenpartnership.com>
	 <20090502172838.GC6466@racke> <18941.10725.335758.894491@notabene.brown>
	 <20090505174831.GD14192@suse.de>
Content-Type: text/plain
Date: Tue, 05 May 2009 17:51:29 +0000
Message-Id: <1241545889.3312.62.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 19:48 +0200, Lars Marowsky-Bree wrote:
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
> 
> I think I've not read anything in the last 3-5 days which still would
> rate as a reason for rejection or delay.
> 
> Did I miss something?

No ... I'd agree with that.  drbd essentially qualifies as a driver
under our new merge rules, so we should be thinking about blockers to
getting it into the tree first (serious issues) and working out kinks
(like raid unification) after it gets in.

James


