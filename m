Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXGIP1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXGIP1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXGIP1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:27:48 -0400
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:53824 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbXGIP1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:27:47 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com>
	<200707091602.27312.oliver@neukum.org> <87bqelwt4p.fsf@jbms.ath.cx>
	<200707091709.09912.oliver@neukum.org>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 11:27:44 -0400
In-Reply-To: <200707091709.09912.oliver@neukum.org> (Oliver Neukum's message
	of "Mon\, 9 Jul 2007 17\:09\:09 +0200")
Message-ID: <87y7hpvbpr.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oliver@neukum.org> writes:

> Am Montag, 9. Juli 2007 schrieb Jeremy Maitin-Shepard:
>> Oliver Neukum <oliver@neukum.org> writes:
>> 
>> [snip]
>> 
>> > Hm, once the new kernel is booted, this decision is irrevocable, isn't it?
>> > Is there any way to deal with errors by handing control back?
>> 
>> Returning to the old kernel can be done by telling drivers to set the
>> hardware to the appropriate state, then copying the backed up memory
>> back to the beginning of physical memory, and finally jumping to the old
>> kernel.  It would be much like what is done to resume from hibernation.

> If you can do that, why load a new kernel image?

The challenges in doing that are analogous to the challenges in
suspending to RAM, for which it has been agreed that drivers should be
fixed such that the freezer is not necessary.

The hard part of hibernate is not creating the snapshot; rather, the
hard part is writing the snapshot, and allowing the user some
flexibility in how and where the snapshot is written.  The kdump
approach allows complete flexibility in writing the snapshot
(essentially any kernel or user space facility can be used), while not
interfering at all with the snapshot state.

-- 
Jeremy Maitin-Shepard
