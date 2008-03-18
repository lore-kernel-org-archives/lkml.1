Return-Path: <linux-kernel-owner+w=401wt.eu-S965271AbYCSVM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbYCSVM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbYCST7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36143 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761858AbYCST7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:25 -0400
Date: Wed, 19 Mar 2008 00:00:45 +0100
From: Pavel Machek <pavel@suse.cz>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Len Brown <len.brown@intel.com>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080318230045.GA2638@elf.ucw.cz>
References: <200803120129.25585.rjw@sisk.pl> <200803172317.33745.rjw@sisk.pl> <20080318130642.GA1609@elf.ucw.cz> <20080318130710.GB1609@elf.ucw.cz> <20080318170706.GA1580@elf.ucw.cz> <47E00E8E.2000401@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E00E8E.2000401@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-18 21:48:46, Alexey Starikovskiy wrote:
> Pavel Machek wrote:
>> On Tue 2008-03-18 14:07:10, Pavel Machek wrote:
>>> On Tue 2008-03-18 14:06:42, Pavel Machek wrote:
>>>> Confirmed, suspend slowness is in 2.6.25-rc6, too. It takes 15 seconds
>>>> to suspend/resume, while 2.6.24 takes 9. Thinkpad x60.
>>> IIRC 2.6.25-rc5 was "fast".
>>
>> rc6:
>>
>> CPU0 attaching sched-domain:
>>  domain 0: span 3
>>   groups: 1 2
>> CPU1 attaching sched-domain:
>>  domain 0: span 3
>>   groups: 2 1
>> CPU1 is up
>> ACPI: EC: missing OBF confirmation, don't expect it any longer.
> This means that either ACPI interrupt or EC GPE is already disabled,
> but readings from EC continue. 

...and I was getting it with "fast" suspends, too, so this may not be
the core reason.

I should get some sleep soon, perhaps intel has some x60 machines
around?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
