Return-Path: <linux-kernel-owner+w=401wt.eu-S1763967AbZDCMjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763967AbZDCMjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZDCMjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:39:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54070 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZDCMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:39:23 -0400
Date: Fri, 3 Apr 2009 14:39:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403123914.GA1391@ucw.cz>
References: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327051338.GP6239@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'm utterly and screamingly bored of this "Blame userspace" attitude. 
> 
> I'm not blaming userspace.  I'm blaming ourselves, for implementing an
> attractive nuisance, and not realizing that we had implemented an
> attractive nuisance; which years later, is also responsible for these
> latency problems, both with and without fsync() ---- *and* which have
> also traied people into believing that fsync() is always expensive,
> and must be avoided at all costs --- which had not previously been
> true!

Well... fsync is quite expensive. If your disk is down, it costs 3+
and 3J+. If your disk is up, it will only take 20msec+.

OTOH the rename trick on ext3 costs approximately nothing...

Imagine those desktops where they want windows layout
preserved. Having 30 second old layout is acceptable, loosing layout
altogether is not. If you add fsync to the window manager, user will
see those 3seconds+ delays, unless window manager gets multithreaded.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
