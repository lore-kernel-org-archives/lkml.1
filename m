Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbYKCKkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbYKCKkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYKCKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:40:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59103 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYKCKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:40:36 -0500
Date: Mon, 3 Nov 2008 11:40:35 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com
Subject: Re: 2.6.28-rc2-git1: spitz still won't boot
Message-ID: <20081103104035.GA19153@atrey.karlin.mff.cuni.cz>
References: <20081031150601.GA1457@ucw.cz> <200810312255.38112.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810312255.38112.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Friday, 31 of October 2008, Pavel Machek wrote:
> > Hi!
> > 
> > ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
> > the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
> > compile, so bisect is quite hard to do. Any ideas?
> 
> Is this a regression from .27?

Yes, it is (*).
									Pavel
(*) Okay, so 2.6.27 does not boot due to the 'reset floating'
bug. 'reset floating' is fixed in 2.6.28-rc1, and compilation of spitz
is fixed in 2.6.28-rc2, but it still will not boot.

So yes, some new spitz-breaking bug got introduced. But no, 2.6.27
will not boot due to other bug. 2.6.26 boots.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
