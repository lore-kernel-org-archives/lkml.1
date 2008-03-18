Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYCRNcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYCRNcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYCRNbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:31:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51146 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYCRNba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:31:30 -0400
Date: Tue, 18 Mar 2008 13:07:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Suspend and hibernation patchset against -rc6
Message-ID: <20080318120704.GA1841@elf.ucw.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803172317.33745.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > For everyone interested, I have put together a patchset containing some "fresh"
> > patches related to suspend and hibernation, on top of 2.6.25-rc5, located at:
> > 
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc5/patches/
> 
> There's a new patchset against 2.6.25-rc6 at:
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.25-rc6/patches/
> 
> It contains some more patches, specifically the "legacy PM removal" series, the
> fixed "PM: make wakeup flags available whenever CONFIG_PM is set" series posted
> recently by Alan (the second patch rebased by me), the Johannes' apm-emulation
> patch and the patches introducing the new suspend/hibernation callbacks I sent
> yesterday.

Ok, I ran basic tests on thinkpad x60, and they seem to work.

...one strange thing is I'm seeing some delays, I'll investigate a bit
more.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
