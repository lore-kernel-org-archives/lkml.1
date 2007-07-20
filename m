Return-Path: <linux-kernel-owner+w=401wt.eu-S934610AbXGTWtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbXGTWtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXGTWsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:48:55 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:39004 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbXGTWsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:48:55 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: david@lang.hm, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707201830470.5241-100000@iolanthe.rowland.org>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 20 Jul 2007 18:48:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.0707201830470.5241-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Fri\, 20 Jul 2007 18\:35\:16 -0400 \(EDT\)")
Message-ID: <87zm1qofnr.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Fri, 20 Jul 2007, Jeremy Maitin-Shepard wrote:
>> >> when doing a suspend-to-ram you get to a point where you just don't use 
>> >> any userspace.
>> 
>> > What do you mean?  How can you prevent user tasks from running?  That's 
>> > basically what the freezer does, and the whole point of this approach 
>> > is to eliminate the freezer.  Right?
>> 
>> Presumably no tasks at all would be scheduled.

> How would you prevent tasks from being scheduled?  How would you
> prevent drivers from deadlocking because in order to put their device
> in a low-power state they need to acquire a lock which is held by a
> user task?

Perhaps this isn't an issue once the device is already quiesced.  I'm
just conjecturing.

[snip]

-- 
Jeremy Maitin-Shepard
