Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZBNPR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZBNPR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 10:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZBNPQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 10:16:56 -0500
Received: from thunk.org ([69.25.196.29]:34762 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZBNPQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 10:16:53 -0500
Date: Sat, 14 Feb 2009 09:29:15 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [Bug #12604] Commit 31a12666d8f0c22235297e1c1575f82061480029
	slows down Berkeley DB
Message-ID: <20090214142915.GE26628@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.gUG.420jJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sWhNs83kKPE.A.gUG.420jJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 08:21:42PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12604
> Subject		: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
> Submitter	: Jan Kara <jack@suse.cz>
> Date		: 2009-01-30 1:23 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31a12666d8f0c22235297e1c1575f82061480029
> References	: http://marc.info/?l=linux-kernel&m=123327862901800&w=4
> 

Note: this has been fixed in mainline as of 2.6.29-rc5, in commit
3a4c6800.  So this bug can be closed now...

						- Ted

P.S.  One good thing about the commit 31a12666 was that made an
otherwise very hard to hit potential deadlock condition in ext4 very
easy to hit, and thus for us to detect and to fix.  So, thanks.  :-)
