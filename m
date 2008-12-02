Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbYLBT4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbYLBT4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYLBTz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:55:57 -0500
Received: from gherkin.frus.com ([192.158.254.49]:34438 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYLBTz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:55:56 -0500
X-Greylist: delayed 1640 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 14:55:56 EST
Date: Tue, 2 Dec 2008 13:28:34 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.28-rc7
Message-ID: <20081202192834.GA26259@gherkin.frus.com>
References: <1228237136.3331.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228237136.3331.17.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 10:58:56AM -0600, James Bottomley wrote:
> This is quite a hefty update for so late. It includes a slew of block
> timer related fixes (we moved to using block timers when the 2.6.28
> merge window opened).  The bad news is that I still don't think we have
> all the block timer related bugs caught and fixed.  There's also a slew
> of zfcp (s390 driver) fixes and a few miscellaneous others (including
> another regression bugzilla fix, the hang in starved list processing).

I'll give this a try.  None of the 2.6.28-rcX versions I've tried have
lasted more than a few hours at best before panicing with a block layer
timeout.  My test system uses the aic7xxx driver with a 2930U2 adapter.
I didn't report the regression relative to 2.6.27 because I figured
something this major was going to get caught without another "me too"
report that I was too busy to generate and provide the necessary
diagnostic and followup on anyway :-).

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
