Return-Path: <linux-kernel-owner+w=401wt.eu-S934389AbXEVLam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbXEVLam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbXEVLaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:30:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3445 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757678AbXEVLaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:30:18 -0400
Date: Sun, 20 May 2007 19:55:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>,
       Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070520195526.GA5235@ucw.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518215731.GB10655@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >  How do you know that the corruption was caused by 2.6.21-rc1 ?
> > >  Isn't it possible that the corruption was created by an earlier
> > >  kernel, but only detected when a forced fsck was run - which just
> > >  happened to be while you were running 2.6.21-rc1 ...
> > > 
> > >  My point is that, as far as I can see, there's nothing tying
> > >  2.6.21-rc1 specifically to this corruption... or?
> > 
> > You might be right, but I thought maybe more probably is the cause in kernel
> > as that is what I have changed recently. ;) Or maybe someone can at leats say
> > "No, no changes to be considered between 2.6.20.6 and 2.6.22-rc1.". ;)
> 
> Well, given that your e2fsck transcript started with this:
> 
> > /dev/hda3 has been mounted 38 times without being checked, check forced
> 
> #1, This is why periodic checks are a good thing; it catches problems
> that could stay hidden and result in data loss sooner rather later.

Actually, I see something funny with periodic checks here. It claims
'filesystem check on next boot' for >10 boots now.

It is sharp zaurus machine, and the filesystem tends to _never_ be
unmounted correctly (broken scripts), so I get journal replay each
time.

Anyone else sees that?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
