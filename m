Return-Path: <linux-kernel-owner+w=401wt.eu-S936360AbXGQU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936360AbXGQU4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbXGQU42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:56:28 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:63358 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbXGQU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:56:27 -0400
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
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
	<200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
	<Pine.LNX.4.64.0707171335180.2467@asgard.lang.hm>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 16:56:14 -0400
In-Reply-To: <Pine.LNX.4.64.0707171335180.2467@asgard.lang.hm>
	(david@lang.hm's message of "Tue\, 17 Jul 2007 13\:37\:08 -0700 \(PDT\)")
Message-ID: <87bqeag369.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

[snip]

>>> * figure out which devices can wake up
>>> * put devices into low power states (wake-up devices are placed in the Dx
>>> states compatible with the wake capability, the others are powered off)

> this can't be done by the image-saving kernel if that kernel doesn't know about
> the device.

The image-saving kernel can be made to know about all of the "wake up"
devices; all other devices should have already been powered off by the
"hibernated" kernel.

-- 
Jeremy Maitin-Shepard
