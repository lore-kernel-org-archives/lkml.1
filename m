Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752259AbYLRSNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbYLRSNR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYLRSMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:12:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40694 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYLRSMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:12:51 -0500
Date: Thu, 18 Dec 2008 19:12:49 +0100
From: Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Pascal Terjan <pterjan@mandriva.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
        pterjan@mandriva.org, linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Possible ext3 corruption with 1K block size
Message-ID: <20081218181249.GD6797@atrey.karlin.mff.cuni.cz>
References: <200810150724.42180.arvidjaar@mail.ru> <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru> <48F601A5.1050405@redhat.com> <1224164860.11578.14.camel@plop> <48F751E9.8070705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48F751E9.8070705@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Eric,

> Pascal Terjan wrote:
> > Le mercredi 15 octobre 2008 à 09:43 -0500, Eric Sandeen a écrit :
> >> Andrey Borzenkov wrote:
> >>> On Wednesday 15 October 2008, Eric Sandeen wrote:
> >>
> >>>> My kingdom for a testcase... does anyone have simple steps to reproduce
> >>>> this?  Or do they all start with "install mandriva on a 1k block size
> >>>> system?"  :)
> >>>>
> >>> May be RH will do? :)
> >> I did try a 1k-block root fs Fedora install, and didn't see any problems...
> >>
> >>> As indicated by last comment, Pascal has some ways to trigger it; I
> >>> forgot to Cc to him initially; doing it now.
> >> Ok, good deal.
> >>
> > 
> > On my test machine I reproduce it easily : rpm --rebuilddb and if the db
> > is not detected to be corrupted yet it will be after installing a few
> > packages (tested again with 2.6.27).
> > 
> > If I do the rebuilddb on a 2.6.17 and then reboot on a recent kernel,
> > then I can install/uninstall thousands of packages without any
> > corruption.
> 
> so it seems to be the database rebuilding, under a recent kernel, which
> causes the problem?  installing under a recent kernel is ok, as long as
> the db was created on an older kernel?
> 
> Ok that's a good clue...
  Have you been able to track this down? Anything interesting?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
