Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYCST0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYCST0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYCSTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:24:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbYCSTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:39 -0400
Date: Wed, 19 Mar 2008 07:47:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
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
In-Reply-To: <20080319114851.GB21270@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.1.00.0803190742450.3020@woody.linux-foundation.org>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org> <20080318225201.GA2115@elf.ucw.cz>
 <alpine.LFD.1.00.0803181736340.3020@woody.linux-foundation.org> <20080319114851.GB21270@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Pavel Machek wrote:
> 
> Ok, 7c0... is innocent. Reverting not only the mdelay, but also rest
> of drivers/acpi/ec.c patch fixed the
> "rc6-breaks-backlight-in-X-over-lid-close", good.

Can you clarify a bit?

Do you mean that the full revert of 2c81ce4 that already got committed is 
sufficient for you, or do you need to totally undo everything we've done 
to ec.c since -rc5, and thus also to revert the _other_ revert we did (in 
4af8e10a6c57e7292862bd1703712f0565c7e429)?

In other words, what does "rest of drivers/acpi/ec.c patch" mean? Does it 
mean just the IRQ storm patch, or does it mean everything that happened in 
drivers/acpi/ec.c since 2.6.25-rc5?

			Linus
