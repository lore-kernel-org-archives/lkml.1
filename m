Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZCEQyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZCEQyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZCEQy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:54:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44823 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZCEQy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:54:26 -0500
Date: Thu, 5 Mar 2009 17:54:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090305165407.GB1379@ucw.cz>
References: <200902191356.53584.rjw@sisk.pl> <200902231504.27879.oliver@neukum.org> <20090227101818.GH4582@elf.ucw.cz> <200902271622.25141.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902271622.25141.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-02-27 16:22:19, Oliver Neukum wrote:
> Am Freitag 27 Februar 2009 11:18:18 schrieb Pavel Machek:
> > > We can just as well have a class of tasks less important than power
> > > saving. They'd just run when power saving is not active for some other
> > > reason. Just like other such schemes we end up with the problem
> > > of priority inversion with locking.
> >
> > Ok, I guess this could be interesting in some cases... maybe. What are
> > real examples of such tasks?
> 
> The classical example is Seti@HOME.

So it is okay for you to waste 30W on seti on running machine on
battery power but you can't waste those remaining 10W...? I guess I'd
either expect seti to stop at battery power...

suspended machine 0.3W
awake machine 10W
machine running seti 40W

...? (thinkpad x60).

Ok... for something less computing intensive, it might make
sense... but I guess those examples are less widespread than you
expect.

> Any monitoring tool like umtsmon
> or kwifimanager.

I'd expect desktop environment to stop wasting cycles/electrons on
that when user can't see the screen.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
