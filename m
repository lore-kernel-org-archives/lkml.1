Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbXI1VPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbXI1VPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXI1VP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:15:26 -0400
Received: from bay0-omc3-s31.bay0.hotmail.com ([65.54.246.231]:37949 "EHLO
	bay0-omc3-s31.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbXI1VPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:15:25 -0400
X-Originating-IP: [69.156.110.168]
X-Originating-Email: [seanlkml@sympatico.ca]
Message-ID: <BAYC1-PASMTP03BE3FCD597E8017F583D1AEB20@CEZ.ICE>
Date: Fri, 28 Sep 2007 17:15:23 -0400
From: Sean <seanlkml@sympatico.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
In-Reply-To: <1190970369.18681.17.camel@chaos>
References: <46FC2245.50907@tiscali.nl>
	<1190967450.18681.10.camel@chaos>
	<20070928012656.0bae3991.akpm@linux-foundation.org>
	<1190968358.18681.14.camel@chaos>
	<20070928085632.GC12086@shadowen.org>
	<1190970369.18681.17.camel@chaos>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2007 21:15:24.0730 (UTC) FILETIME=[AF83A1A0:01C80214]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 11:06:09 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> > The problem with git-commit is who's repo to add the hook to.  I did
> > attempt to do this by picking up each of linus' main releases and then
> > using the git blame engine to attribute each "failure" to a particular
> > commit.  The plan then would be to send a nasty-gram to the committer
> > about violations there-in.

Wouldn't it be easier to pass each commit through checkpatch and
email the committer if there is a problem?  Each commit can be viewed
as a standalone patch afterall; what does blame add?

> The question is, whether we can convince the git developers to integrate
> it. When a commit happens and checkpatch.pl is in scripts/, then run the
> patch through it before doing the actual commit.

Definitely the way to go.  I'm pretty sure the Git guys would agree to
distribute checkpatch.pl along with the existing pre-commit hook.  So
at least enabling checkpatch would be trivial for those convinced to
use it.

Sean
