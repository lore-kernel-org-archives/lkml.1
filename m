Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYAYVQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYAYVQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYAYVQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:16:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46885 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752776AbYAYVQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:16:06 -0500
Date: Fri, 25 Jan 2008 22:16:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH -mm 5/5] b43: Avoid unregistering device objects during
	suspend
Message-ID: <20080125211618.GA2261@elf.ucw.cz>
References: <20080125074746.GC4134@ucw.cz> <Pine.LNX.4.44L0.0801250955210.4190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801250955210.4190-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-25 09:58:00, Alan Stern wrote:
> On Fri, 25 Jan 2008, Pavel Machek wrote:
> 
> > Maybe we should have global suspend_in_progress (or maybe system_state
> > == suspending?) and automatically switch to schedule_removal() while
> > it is set?
> 
> :-)  There was a time a couple of years ago when you objected violently 
> to the mere suggestion of such a global variable!

Lets say I was young at stupid...? ;-).

> It's not a bad idea IMO.  But if it does get implemented, a global
> function would be better than a global variable.  It would provide
> more encapsulation.

Agreed.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
