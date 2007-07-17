Return-Path: <linux-kernel-owner+w=401wt.eu-S936545AbXGQUxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936545AbXGQUxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936346AbXGQUux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:50:53 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39596
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394AbXGQUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:50:51 -0400
Date: Tue, 17 Jul 2007 13:39:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <87k5syg3yi.fsf@jbms.ath.cx>
Message-ID: <Pine.LNX.4.64.0707171337290.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
 <200707171802.30903.rjw@sisk.pl> <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
 <200707172150.44417.rjw@sisk.pl> <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
 <87k5syg3yi.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jeremy Maitin-Shepard wrote:

> david@lang.hm writes:
>
> [snip]
>
>> the non-ACPI hibernate behaves very differently, and for some people (and I
>> think I am one of them) it will meet their needs better then _any_ of the ACPI
>> suspends.
>
> It may have certain differences from the user point of view, but from
> the implementation view, it seems that it is nearly exactly the same.
> The only differences seem to be:
>
> - rather than shutting down, do whatever is necessary to stick the
>   system in S4 state.
>
> - make sure ACPI isn't initialized by the "load image" kernel
>
> - rather than "resume from hibernate" ACPI by initializing it normally,
>   issue the special hibernate-related methods.
>
> Thus, it seems that supporting ACPI S4 will have a very minimal affect
> on the hibernate implementation.

from what Rafael is saying supporting ACPI S4 mode requires a very 
fundamentally different restore approach, and in addition imposes very 
different restrictions on what can be done with the machine while it's 
suspended.

David Lang
