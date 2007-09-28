Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbXI1I5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbXI1I5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbXI1I5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:57:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42165 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759096AbXI1I5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:57:15 -0400
Date: Fri, 28 Sep 2007 01:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
Message-Id: <20070928015559.f8b63f43.akpm@linux-foundation.org>
In-Reply-To: <20070928083037.GA18295@elte.hu>
References: <46FC2245.50907@tiscali.nl>
	<1190967450.18681.10.camel@chaos>
	<20070928012656.0bae3991.akpm@linux-foundation.org>
	<20070928083037.GA18295@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:30:37 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
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
> i automatically run it for every patch i submit or push out via git.

you're hardly anyone ;)

> > I think we're ready to wire checkpatch up to a email robot which 
> > monitors the mailing lists and sends people nastygrams.  I bet that'll 
> > be popular ;)
> 
> heh ;-) It could be automated for patches that are sent out with a 
> Signed-off-by [or a Reviewed-by] line. If you send a SoB patch that is 
> broken, prepare to get a nastygram. (Initially i'd suggest the nastygram 
> to Cc: to a different email list, not lkml.)

I was thinking it would reply to the sender only.

I have this vision of dragging my sorry butt to the keyboard in the morning
to be greeted by the usual shower of tab-replaced, space-stuffed
wordwrappery, except now each one is followed ten minutes later by a fixed up
version.

One can dream.
