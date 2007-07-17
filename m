Return-Path: <linux-kernel-owner+w=401wt.eu-S934936AbXGQUyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936AbXGQUyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936267AbXGQUyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:54:17 -0400
Received: from sccrmhc11.comcast.net ([63.240.77.81]:48087 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935417AbXGQUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:54:16 -0400
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
	<200707172217.01890.rjw@sisk.pl>
	<Pine.LNX.4.64.0707171328450.2467@asgard.lang.hm>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 17 Jul 2007 16:54:08 -0400
In-Reply-To: <Pine.LNX.4.64.0707171328450.2467@asgard.lang.hm>
	(david@lang.hm's message of "Tue\, 17 Jul 2007 13\:34\:24 -0700 \(PDT\)")
Message-ID: <87fy3mg39r.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

[snip]

> this is where we disagree.

> why not? if all that the hibernated kernel does is to suspend-to-ram and makes
> no changes to disks or TCP connections anything that it does do would be lost if
> power were to fail and you instead did a restore from disk.

It would be okay to switch the "hibernated" kernel in order to
e.g. initiate a suspend to ram provided that everything is done
atomically with interrupts off, for instance.  It is not clear, though,
that it is possible to suspend to ram atomically like that.

There is also the question of what state the devices will be in when
switching back from the "save image" kernel to the "hibernated" kernel.

[snip]

-- 
Jeremy Maitin-Shepard
