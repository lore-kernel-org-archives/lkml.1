Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbXI1JGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbXI1JGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXI1JGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:06:12 -0400
Received: from www.osadl.org ([213.239.205.134]:43435 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753630AbXI1JGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:06:11 -0400
Subject: Re: [PATCH] spin_lock_unlocked cleanups
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070928085632.GC12086@shadowen.org>
References: <46FC2245.50907@tiscali.nl> <1190967450.18681.10.camel@chaos>
	 <20070928012656.0bae3991.akpm@linux-foundation.org>
	 <1190968358.18681.14.camel@chaos>  <20070928085632.GC12086@shadowen.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 11:06:09 +0200
Message-Id: <1190970369.18681.17.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 09:56 +0100, Andy Whitcroft wrote:
> > > I think we're ready to wire checkpatch up to a email robot which monitors
> > > the mailing lists and sends people nastygrams.  I bet that'll be popular ;)
> > 
> > We should wire it up to git-commit as well. A lot of that comes in via
> > git subsystems.
> 
> The problem with git-commit is who's repo to add the hook to.  I did
> attempt to do this by picking up each of linus' main releases and then
> using the git blame engine to attribute each "failure" to a particular
> commit.  The plan then would be to send a nasty-gram to the committer
> about violations there-in.
> 
> I'll try and find some time to get this bit polished and at least
> emailing me.

The question is, whether we can convince the git developers to integrate
it. When a commit happens and checkpatch.pl is in scripts/, then run the
patch through it before doing the actual commit.

	tglx



