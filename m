Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbZCAWsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbZCAWsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 17:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbZCAWsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 17:48:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41351 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbZCAWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 17:48:44 -0500
Date: Sun, 1 Mar 2009 23:51:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090301225117.GD1961@elf.ucw.cz>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090217142001.GB12378@bulgaria.corp.google.com> <20090217064630.688bf639@infradead.org> <20090217152811.GA12686@bulgaria.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217152811.GA12686@bulgaria.corp.google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI!

> > > Of course that still doesn't address userspace.  Aggressively going to
> > > suspend lets us compensate for userspace programs that do somewhat
> > > silly things (I agree that it would be best if they didn't but they
> > > do and getting *everyone* to write their userspace code to avoid
> > > spinning or avoid waking up on short-duration timers to poll is a
> > > losing battle).
> > 
> > actually with powertop... on the open source side things are actually
> > won. It took all of 6 months...
> > I don't see that as a valid excuse. In fact, if this kind of solution
> > makes real userspace scheduled timers to be missed then I consider it a
> > serious functionality misfeature.
> 
> While you can't expect the kernel to solve all the problems of
> userspace, here's the broad situation one could end up in
> (note this specific sequence is generic and not based on any one
> specific product experience):
> 
> - carrier deploys a device 
> - carrier agrees to allow installation of arbitrary third party apps
>   without some horrible certification program requiring app authors
>   to jump through hoops, wait ages for approval, etc
> - users rejoice and install all kinds of apps
> - some apps are poorly written and impact battery life
> - users complain to carrier about battery life
> 
> You will end up with some crappy apps that do really dumb things.
> However, even if they're badly written users may still install and use
> these apps because hey, they do something the user likes.

Yes, crappy apps exist. Fortunately for you, they are written in Java,
so you can do all the magic in the JVM, no need to hack it into
kernel.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
