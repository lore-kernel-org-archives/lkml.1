Return-Path: <linux-kernel-owner+w=401wt.eu-S936889AbYCSVR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936889AbYCSVR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761956AbYCST7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36154 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761902AbYCST7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:34 -0400
Date: Wed, 19 Mar 2008 00:54:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
Message-ID: <20080318235457.GA1936@elf.ucw.cz>
References: <20080318100106.GA10830@elf.ucw.cz> <Pine.LNX.4.44L0.0803181103410.1476-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803181103410.1476-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So... we do prepare() but it detects new child, so it returns -EAGAIN.
> >   so we call complete() based on description above
> > ...and then we call prepare() to suspend again?
> 
> You misunderstood (maybe the comment needs to be clarified as above).  

Yes, please :-).

> If prepare() returns any error (including -EAGAIN) then complete() does
> not get called.  If prepare() returns successfully but the PM core
> detects that a new child was added while prepare() was running, then we
> call complete(), suspend the child, and call prepare() again.

Ok.

> > > + * @suspend: Executed before putting the system into a sleep state in which the
> > > + *	contents of main memory are preserved.  Quiesce the device, put it into
> > 
> > content....is?
> 
> It's okay to use "contents" -- analogous to the table of contents in a
> book.  It's one of those weird corner cases where either alternative is
> acceptable.

Ok -- I guess I should get that english course ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
