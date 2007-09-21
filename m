Return-Path: <linux-kernel-owner+w=401wt.eu-S1764810AbXIUVSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764810AbXIUVSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXIUVSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:18:36 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.212]:34663 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbXIUVSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:18:35 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org>
	<200709212253.02158.rjw@sisk.pl> <87d4wb680u.fsf@jbms.ath.cx>
	<200709212325.39599.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 21 Sep 2007 17:16:59 -0400
In-Reply-To: <200709212325.39599.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri\, 21 Sep 2007 23\:25\:37 +0200")
Message-ID: <878x6z67n8.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, 21 September 2007 23:08, Jeremy Maitin-Shepard wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > On Friday, 21 September 2007 22:26, Jeremy Maitin-Shepard wrote:
>> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> >> 
>> >> [snip]
>> >> 
>> >> > The ACPI NVS area is explicitly marked as reserved and we don't save it.
>> >> > On x86_64 we don't save any memory areas marked as reserved and yet the
>> > above
>> >> > happens.
>> >> 
>> >> I think you have mentioned before, though, that ACPI is first
>> >> initialized by the boot kernel, before it is later initialized by
>> >> resuming kernel.  This could well be the source of the problem.
>> 
>> > No, it's not.  I have tested that too with an ACPI-less boot kernel.
>> 
>> Well, it seems that there just must be some other bug.  I would define
>> anything that differs between the post-resume initialization of ACPI

> I'm not sure what you mean.

>> from the normal boot initialization of ACPI as a bug.  If the interaction
>> with the hardware is the same, then the behavior will be the same.

> The ACPI platform firmware is allowed to preserve information accross the
> hibernation-resume cycle, so this need not be the same.

All of my comments related to the case where S4 is not being used
(instead the system is just powered off normally), and a boot kernel
that does not initialize ACPI is used.  In that case, the ACPI platform
firmware should not be able to distinguish a normal boot from a resume
from hibernation.

-- 
Jeremy Maitin-Shepard
