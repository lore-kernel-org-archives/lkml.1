Return-Path: <linux-kernel-owner+w=401wt.eu-S936838AbYCSVQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936838AbYCSVQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761901AbYCST7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36156 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbYCST7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:34 -0400
Date: Wed, 19 Mar 2008 11:19:47 +0100
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
Message-ID: <20080319101947.GA2963@elf.ucw.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz> <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > It will take a while. My .git directory is 7G, and I'd like to do a
> > backup before playing with git.
> 
> Ouch, what have you done? It should be about 200MB, not 7GB.
> 
> > git gc does not exist here, so I guess I need to update git, too :-(.
> 
> Well, even with old git you can just do 
> 
> 	git repack -a -d
> 
> and in your case you'll probably have to leave it running overnight, 
> because it's going to take hours since you've clearly not ever repacked it 
> before and as a result it's going to do lots and lots of IO (all that 7GB 
> and then read much of it twice).

And 10 minutes later, .git directory is 200MB. Thanks!


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
