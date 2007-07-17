Return-Path: <linux-kernel-owner+w=401wt.eu-S937025AbXGQVxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937025AbXGQVxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764011AbXGQVxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:53:30 -0400
Received: from sccrmhc11.comcast.net ([63.240.77.81]:48749 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764700AbXGQVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:53:29 -0400
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
	<200707172257.22959.rjw@sisk.pl>
	<Pine.LNX.4.64.0707171345270.2467@asgard.lang.hm>
	<200707172337.24683.rjw@sisk.pl>
	<Pine.LNX.4.64.0707171430050.2467@asgard.lang.hm>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 17:53:26 -0400
In-Reply-To: <Pine.LNX.4.64.0707171430050.2467@asgard.lang.hm>
	(david@lang.hm's message of "Tue\, 17 Jul 2007 14\:42\:58 -0700 \(PDT\)")
Message-ID: <87wswyelyh.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

[snip]
 
>> There are NO ACPI LIMITS!  There only are things that you need to implement
>> if you're going to support ACPI, but they need not be used ALWAYS, no?

> yes there are limits. the fact that you can't remove the battery in S4 mode
> without messing things up is a limit,

You won't mess things up as long as the resuming kernel knows that it
should resume as if the system were shutdown, rather than sent to S4
state.  Maybe it is even possible to detect what type of resuming is
needed automatically.  Similarly, booting another OS shouldn't be a
problem, except that if you do it without powering off the system first,
some devices might not work under the other OS if the other OS doesn't
initialize them properly.

[snip]

-- 
Jeremy Maitin-Shepard
