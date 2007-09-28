Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbXI1Ict@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbXI1Ict (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXI1Icl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:32:41 -0400
Received: from www.osadl.org ([213.239.205.134]:38537 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751545AbXI1Icl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:32:41 -0400
Subject: Re: [PATCH] spin_lock_unlocked cleanups
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roel <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070928012656.0bae3991.akpm@linux-foundation.org>
References: <46FC2245.50907@tiscali.nl> <1190967450.18681.10.camel@chaos>
	 <20070928012656.0bae3991.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 10:32:38 +0200
Message-Id: <1190968358.18681.14.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 01:26 -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 10:17:30 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > can we please add this to checkpatch.pl ? 
> > 
> > > -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> > > +DEFINE_SPINLOCK(bpci_lock);
> 
> That check is already in checkpatch.  Problem is that hardly anyone
> runs the thing.

Sigh, I forgot that perl is write only. :)

> I think we're ready to wire checkpatch up to a email robot which monitors
> the mailing lists and sends people nastygrams.  I bet that'll be popular ;)

We should wire it up to git-commit as well. A lot of that comes in via
git subsystems.

> (I'd love it if it could detect wordwrapped and tab-expanded patches, too. 
> You wouldn't _believe_...)

I know ...

	tglx


