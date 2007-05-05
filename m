Return-Path: <linux-kernel-owner+w=401wt.eu-S934058AbXEGNx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbXEGNx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934053AbXEGNx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:53:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4734 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934023AbXEGNxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:53:24 -0400
Date: Sat, 5 May 2007 11:42:54 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070505114253.GA5119@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280041.17617.rjw@sisk.pl> <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org> <200704280145.26253.rjw@sisk.pl> <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org> <alpine.LFD.0.98.0704271706100.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704271706100.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The "let's stop all kernel threads" is superstition. It's the same kind of 
> > superstition that made people write "sync" three times before turning off 
> > the power in the olden times. It's the kind of superstition that comes 
> > from "we don't do things right, so let's be vewy vewy quiet and _pray_ 
> > that it works when we are beign quiet".
> 
> Side note: while I think things should probably *work* even with user 
> processes going full bore while a snapshot it taken, I'll freely admit 
> that I'll follow that superstition far enough that I think it's probably a 
> good idea to try to quiesce the system to _some_ degree, and that stopping 
> user programs is a good idea. Partly because the whole memory shrinking 
> thing, and partly just because we should do the snapshot with hw IO queues 
> empty.
> 
> But I don't think it would necessarily be wrong (and in many ways it would 
> probably be *right*) to do that IO queue stopping at the queue level 
> rather than at a process level. Why stop processes just becasue you want 
> to clean out IO queues? They are two totally different things!

Actually, I'd like to stop I/O queues; if there was easy way to do
that, I'll happily switch. Notice that we'll need to stop 'I/O queues'
of the char devices, too...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
