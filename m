Return-Path: <linux-kernel-owner+w=401wt.eu-S936701AbYCSVQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936701AbYCSVQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbYCST7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36150 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761896AbYCST7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:30 -0400
Date: Wed, 19 Mar 2008 15:54:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080319145448.GA26416@elf.ucw.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz> <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org> <20080319114851.GB21270@atrey.karlin.mff.cuni.cz> <alpine.LFD.1.00.0803190742450.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803190742450.3020@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-19 07:47:06, Linus Torvalds wrote:
> 
> 
> On Wed, 19 Mar 2008, Pavel Machek wrote:
> > 
> > Ok, 7c0... is innocent. Reverting not only the mdelay, but also rest
> > of drivers/acpi/ec.c patch fixed the
> > "rc6-breaks-backlight-in-X-over-lid-close", good.
> 
> Can you clarify a bit?
> 
> Do you mean that the full revert of 2c81ce4 that already got committed is 
> sufficient for you, or do you need to totally undo everything we've done 
> to ec.c since -rc5, and thus also to revert the _other_ revert we did (in 
> 4af8e10a6c57e7292862bd1703712f0565c7e429)?

I believe that current mainline is okay, and will test that theory
shortly.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
