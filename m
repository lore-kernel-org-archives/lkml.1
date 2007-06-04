Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbXFDWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbXFDWv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXFDWvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:51:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38373 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752933AbXFDWvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:51:49 -0400
Date: Tue, 5 Jun 2007 00:51:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: A kexec approach to hibernation
Message-ID: <20070604225143.GF2711@elf.ucw.cz>
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz> <20070604220910.GB2515@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604220910.GB2515@andrew.cmu.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > To me, it seems a lot easier to get right than the current approaches.
> > 
> > Well, you are certainly welcome to create the patch. "suspend3" name
> > is still free, AFAICT.
> 
> I could be sneaky and call it "hibernate".  Probably nicer though to use the 
> name "kexec hibernate" to be later simplified to just "hibernate".
> 
> I was hoping that everyone would like the idea so much that they would rush to 
> implement it, so that I wouldn't have to try.  (I haven't written

That apparently did not happen, that much should be clear by now.

> > If _I_ were willing to add some runtime overhead to make hibernation
> > simpler, I'd just use some virtualization to do that... with added
> > advantage of "hibernate here, resume on different hw".
> 
> I don't believe there is going to be any runtime overhead.

64MB less memory seems like runtime overhead for me. If you know how
to do kexec without pre-reserving memory, I believe kexec/kdump team
will be interested.

> To some extent, (see some of the explanations I gave in the other e-mail I
> sent a few minutes ago in reply to Nigel) I think the kexec appraoch can be
> viewed as a cleaner variant of userspace hibernate.

It also can be viewed as vaporware.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
