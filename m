Return-Path: <linux-kernel-owner+w=401wt.eu-S1761826AbYDNVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826AbYDNVVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYDNVVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:21:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50028 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYDNVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:21:03 -0400
Date: Mon, 14 Apr 2008 23:21:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, benh@kernel.crashing.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
Message-ID: <20080414212142.GC26246@elf.ucw.cz>
References: <200804132147.03579.david-b@pacbell.net> <Pine.LNX.4.44L0.0804141049370.2236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804141049370.2236-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-04-14 10:51:34, Alan Stern wrote:
> On Sun, 13 Apr 2008, David Brownell wrote:
> 
> > I sort of agree.  Looking at it from a whole-system perspective,
> > suspending needs to be able to chitchat with userspace ... and I
> > don't think that can be done *before* writing to /sys/power/state
> > in an acceptably generic/portable way.  (Briefly, applications
> > need to have clean stopping points and be able to arrange system
> > wakeup.  They may well have more work to do than most drivers.)
> 
> Pavel's recent work aside, the only way to initiate a system sleep is 
> from userspace.  So it seems natural for all application notifications 
> to be made by the initiating program, perhaps via dbus.

Actually, my plan is to do without notifications. Userspace should
tell kernel "I'm prepared, you can suspend any time now"...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
