Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbXFMM2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbXFMM2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbXFMM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:28:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40851 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757524AbXFMM2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:28:30 -0400
Date: Wed, 13 Jun 2007 14:28:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070613122823.GA2390@elf.ucw.cz>
References: <20070518213701.GA810@core> <20070611120034.f6d972de.akpm@linux-foundation.org> <1181601771.5064.2.camel@nigel.suspend2.net> <200706121411.56016.rjw@sisk.pl> <1181697460.4910.7.camel@nigel.suspend2.net> <20070613082448.GH13747@elf.ucw.cz> <1181734353.5012.12.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181734353.5012.12.camel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Ok. I'll take Pavel's silence as agreement too. I'll be a little slow
> > > (as usual, nowadays!), but will try to get it done next week. I think I
> > > can in clear conscience do it on Redhat time if I don't manage it
> > > beforehand.
> > 
> > Well, everyone wants it so what can I do... Stefan basically posted 3
> > liner to do that, and that one will probably work... so just test it.
> 
> As he admitted, it's a quick and dirty hack. I'd like to try something
> nicer.

Well, his hack + rename one variable and there's one very nice solution.

> > Oh, and please keep the macro, so it can be moved around .S file for
> > finding out where it crashes.
> 
> Are there other points you'd like to nominate? It would defeat the logic
> for implementing a nice interface if you still have to recompile your
> kernel to test beeping in another place.

Just before entering C would be another interesting point.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
