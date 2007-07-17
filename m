Return-Path: <linux-kernel-owner+w=401wt.eu-S934423AbXGQOWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423AbXGQOWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbXGQOPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:15:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53880 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933490AbXGQOPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:15:46 -0400
Date: Tue, 17 Jul 2007 10:15:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: david@lang.hm
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707162137220.19248@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 david@lang.hm wrote:

> > I agree, it would be good to have a non-ACPI-specific hibernation mode,
> > something which would look to ACPI like a normal shutdown.  But I'm not
> > so sure this is possible.
> 
> why would it not be possible?

> I can't think of anything much more frustrating then thinking that I 
> suspended a system and then discovering that becouse the battery went dead 
> (a complete power loss) that the system wouldn't boot up properly. to me 
> this would be a fairly common condition (when I'm mobile I use the machine 
> until I am out of battery, then stop and it may be a long time (days) 
> before I can charge the thing up again) this would not be a reliable 
> suspend as far as I'm concerned.
> 
> for suspend-to-ram you have to worry about ACPI states and what you are 
> doing with them, for suspend-to-disk you can ignore them and completely 
> power the system off instead.

If the only problem with doing this would be lack of wakeup support
then I'm all for it.  There must be a lot of people who would like
their computers to hibernate with power drain as close to 0 as possible
and who don't care about remote wakeup.  In fact they might even prefer
not to have wakeup support, so the computer doesn't resume at
unexpected times.

Alan Stern

