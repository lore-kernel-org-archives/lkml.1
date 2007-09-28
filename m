Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbXI1I4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbXI1I4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbXI1I4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:56:43 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2314 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbXI1I4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:56:42 -0400
Date: Fri, 28 Sep 2007 09:56:32 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
Message-ID: <20070928085632.GC12086@shadowen.org>
References: <46FC2245.50907@tiscali.nl> <1190967450.18681.10.camel@chaos> <20070928012656.0bae3991.akpm@linux-foundation.org> <1190968358.18681.14.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190968358.18681.14.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 10:32:38AM +0200, Thomas Gleixner wrote:
> On Fri, 2007-09-28 at 01:26 -0700, Andrew Morton wrote:
> > On Fri, 28 Sep 2007 10:17:30 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > can we please add this to checkpatch.pl ? 
> > > 
> > > > -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> > > > +DEFINE_SPINLOCK(bpci_lock);
> > 
> > That check is already in checkpatch.  Problem is that hardly anyone
> > runs the thing.
> 
> Sigh, I forgot that perl is write only. :)
> 
> > I think we're ready to wire checkpatch up to a email robot which monitors
> > the mailing lists and sends people nastygrams.  I bet that'll be popular ;)
> 
> We should wire it up to git-commit as well. A lot of that comes in via
> git subsystems.

The problem with git-commit is who's repo to add the hook to.  I did
attempt to do this by picking up each of linus' main releases and then
using the git blame engine to attribute each "failure" to a particular
commit.  The plan then would be to send a nasty-gram to the committer
about violations there-in.

I'll try and find some time to get this bit polished and at least
emailing me.

-apw
