Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYCST2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYCST2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYCSTZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:25:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbYCSTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:41 -0400
Date: Tue, 18 Mar 2008 10:31:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
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
In-Reply-To: <20080318130710.GB1609@elf.ucw.cz>
Message-ID: <alpine.LFD.1.00.0803181028400.3020@woody.linux-foundation.org>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Mar 2008, Pavel Machek wrote:
>
> On Tue 2008-03-18 14:06:42, Pavel Machek wrote:
> > 
> > Confirmed, suspend slowness is in 2.6.25-rc6, too. It takes 15 seconds
> > to suspend/resume, while 2.6.24 takes 9. Thinkpad x60.
> 
> IIRC 2.6.25-rc5 was "fast".

Can you bisect it? There's only 343 commits between -rc5 and -rc6, so it 
should not take too long to check which commit it is. Even if it should 
take 9 reboots to bisect it entirely, going just five or six will likely 
narrow it down sufficiently that we can probably guess fairly well what 
it's about.

		Linus
