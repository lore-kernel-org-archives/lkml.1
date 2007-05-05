Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXEEG6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXEEG6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 02:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030811AbXEEG6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 02:58:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:56747 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbXEEG6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 02:58:40 -0400
Date: Fri, 4 May 2007 23:03:38 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input patches for 2.6.20
Message-ID: <20070505060338.GA27713@suse.de>
References: <200702180204.48643.dtor@insightbb.com> <200705030107.44990.dtor@insightbb.com> <alpine.LFD.0.98.0705041806210.3808@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705041806210.3808@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 06:19:49PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 3 May 2007, Dmitry Torokhov wrote:
> > 
> > If you have not pulled yet please pull from:
> >
> > ?? ?? ?? ?? master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> > 
> > because master branch will have extra stuff in the next minute or so.
> 
> Hmm. That thing had a conflict with the driver core changes I just pulled 
> from Greg due to Greg removing "struct subsystem".
> 
> The conflict looked really trivial, and I fixed up the obvious places, 
> probably correctly. Please verify.
> 
> Martin, in the process I noticed that the new file
> 
> 	arch/s390/kernel/ipl.c
> 
> seems to be broken by the same thing after the driver core merge. The fix 
> _looks_ equally trivial (change *subsys.kset.kobj into just *subsys.kobj), 
> but I didn't do that trivial thing, because I cannot even test-compile the 
> end result. So can you give it a quick look, please?

Martin, Cornelia already sent me (and lkml) a patch to fix this all up
if you want to just use that instead.

> Greg - maybe more of a heads-up to people next time you do something like 
> this? Did this removal hit -mm? Anyway, it looks like something trivial to 
> fix up after, but ..

Yes, this was in -mm for quite a while, and yes, I knew about the
conflict with the input tree, that's why I waited to send this to you
separate from the first merge set and in the second batch, thinking that
either had already sent his stuff, or was going to do so afterwards, and
would be trivial to fix up.

Sorry about that, sometimes core changes like this take a bit of
coordination across subsystems.

thanks,

greg k-h
