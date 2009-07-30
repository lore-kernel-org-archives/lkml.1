Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZHBMvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZHBMvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 08:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZHBMvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 08:51:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47920 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZHBMvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 08:51:10 -0400
Date: Thu, 30 Jul 2009 11:08:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: linux-kernel@vger.kernel.org, Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [VIA Support]  Instruction timing and cache coherency issues
Message-ID: <20090730090804.GE1364@ucw.cz>
References: <200907250827.43400.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907250827.43400.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Started back in mid-May - long time and a lot of hours later...
> 
> As suggested very early in this examination by others -
> It is a timing issue.  My inserting "lock" for config_mviac7
> was just poking at the edges of the sore spot.  ;)
> 
> The "break through" came yesterday while running (or trying to run)
> FreeBSD-8.0-beta2 on the various machines at hand. . .
> 
> Depending on the cpu model variation and the integrated chipset
> used with that cpu - -
> *) FB-8.0 will run
> *) FB-8.0 will only run in "safe mode"
> *) FB-8.0 panics
> 
> And that pattern is similar to the 2.6.30 cpu model / chipset pattern.
> Scratches head, asking: "now how can that be" with two very different OS designs.
> 
> Diddling with the things I have found that either "fix" or "work around"
> the various timing / cache coherency issues - - -
> Aw, so - found how to affect the timing issues sufficiently so that Linux
> would panic dump rather than deadlock on the troublesum combination - -
> *Functionally the same* panic backtrace that FreeBSD is showing.
> 
> NOW I have a lead into making a "minimum invasive" change so that the 
> kernel is happy - even on the flaky VIA combinations.  Patch RSN, just any month.
> The FreeBSD project can fix their problems themselves.  ;)
> 
> @H.W.  Download the FreeBSD-8.0-beta2 and try running it on your Cloudbook and HP-2133,
> you can see what is happening.  Then you might have a word or two with the silicon growers.
> 

So... you believe you have pinpointed bug in their cpu design?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
