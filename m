Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbXI1IyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbXI1IyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbXI1IyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:54:00 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3813 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbXI1Ix7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:53:59 -0400
Date: Fri, 28 Sep 2007 09:53:47 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
Message-ID: <20070928085347.GB12086@shadowen.org>
References: <46FC2245.50907@tiscali.nl> <1190967450.18681.10.camel@chaos> <20070928012656.0bae3991.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928012656.0bae3991.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 01:26:56AM -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 10:17:30 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > can we please add this to checkpatch.pl ? 
> > 
> > > -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> > > +DEFINE_SPINLOCK(bpci_lock);
> 
> That check is already in checkpatch.  Problem is that hardly anyone
> runs the thing.
> 
> I think we're ready to wire checkpatch up to a email robot which monitors
> the mailing lists and sends people nastygrams.  I bet that'll be popular ;)

That shouldn't be too hard.  checkpatch has been subscribed since birth
but short circuiting the replies to me only.

I guess the main question is whether to reply-all or reply just to the
sender when commenting on patches.  Perhaps for the sanity of the rest
of the world, just the sender makes most sense.

> (I'd love it if it could detect wordwrapped and tab-expanded patches, too. 
> You wouldn't _believe_...)

It should pick up both of these, the word-wrapping is already there as
we detect lines within patch segments which don't start '[ +-]', the
tab-expanded should be picked up as every line would be "don't use
spaces use tabs for indent".

-apw

