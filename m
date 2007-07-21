Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbXGUPlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbXGUPlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXGUPlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:41:05 -0400
Received: from alnrmhc12.comcast.net ([206.18.177.52]:38991 "EHLO
	alnrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXGUPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:41:03 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: david@lang.hm, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
	<200707171802.30903.rjw@sisk.pl>
	<Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
	<200707172150.44417.rjw@sisk.pl>
	<Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
	<20070721102520.GE1902@elf.ucw.cz>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Sat, 21 Jul 2007 11:35:43 -0400
In-Reply-To: <20070721102520.GE1902@elf.ucw.cz> (Pavel Machek's message of
	"Sat\, 21 Jul 2007 12\:25\:20 +0200")
Message-ID: <87ps2lojlc.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

[snip]

> So it will be break at least battery status and "AC plugged in"
> status, because those are handled by ACPI and we do not know how to
> control them by hand.

It seems that it should be possible to initialize ACPI as if the system
just booted up normally.  Then battery status and such should be
correct, since they are correct after normal initialization.

It should be possible to make hibernate look just like a reboot to all
of the devices, including ACPI stuff.

-- 
Jeremy Maitin-Shepard
