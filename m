Return-Path: <linux-kernel-owner+w=401wt.eu-S936101AbXGQUju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936101AbXGQUju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbXGQUjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:39:39 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:43758 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXGQUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:39:38 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
	<200707171802.30903.rjw@sisk.pl>
	<Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
	<200707172150.44417.rjw@sisk.pl>
	<Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 16:39:17 -0400
In-Reply-To: <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
	(david@lang.hm's message of "Tue\, 17 Jul 2007 13\:18\:13 -0700 \(PDT\)")
Message-ID: <87k5syg3yi.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

[snip]

> the non-ACPI hibernate behaves very differently, and for some people (and I
> think I am one of them) it will meet their needs better then _any_ of the ACPI
> suspends.

It may have certain differences from the user point of view, but from
the implementation view, it seems that it is nearly exactly the same.
The only differences seem to be: 

 - rather than shutting down, do whatever is necessary to stick the
   system in S4 state.

 - make sure ACPI isn't initialized by the "load image" kernel

 - rather than "resume from hibernate" ACPI by initializing it normally,
   issue the special hibernate-related methods.

Thus, it seems that supporting ACPI S4 will have a very minimal affect
on the hibernate implementation.

-- 
Jeremy Maitin-Shepard
