Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZBVODd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZBVODd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 09:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZBVODZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 09:03:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58068 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZBVODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 09:03:24 -0500
Date: Sun, 22 Feb 2009 15:03:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090222140311.GF1387@ucw.cz>
References: <200902191356.53584.rjw@sisk.pl> <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Again, the decision to trigger automatic suspend has to be based on some
> > well defined criteria and the (in)activity of devices seems to be one of them.
> 
> I don't know what criteria the system monitor would use.  It might have 
> to be platform-specific.  The Android people seem to have a pretty good 
> idea of what criteria will work for them.
> 
> Inactivity of devices isn't always a good criterion.  There might be a
> background task which wakes up every few seconds to do something as
> long as the system is awake, thereby keeping some device always active.  
> The activity from this background task shouldn't prevent an auto-sleep.

Then we'd need a interface to mark such background task... and what is
reasonable use for such task, anyway? Either its job is neccessary, or
it should not waste power.

IOW maybe it is easier to eliminate such stuff?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
