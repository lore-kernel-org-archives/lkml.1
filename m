Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbXJYRco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbXJYRco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXJYRcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:32:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54015 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbXJYRcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:32:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	<alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	<m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	<200710251906.10210.ak@novell.com> <4720CD80.5030106@zytor.com>
Date: Thu, 25 Oct 2007 11:30:44 -0600
In-Reply-To: <4720CD80.5030106@zytor.com> (H. Peter Anvin's message of "Thu,
	25 Oct 2007 10:08:16 -0700")
Message-ID: <m17ilb5cfv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Andi Kleen wrote:
>>> Especially for accessing the real time clock that has a well
>>> defined hardware interface going through efi an additional
>>> software emulation layer looks like asking for trouble.
>>
>> I agree it's pointless for the hardware clock, but EFI also offers services to
>> write some data to the CMOS RAM
>> which could be very useful to save oops data over reboot.
>> I don't think this can be done safely otherwise without BIOS cooperation.
>>
>
> The ability to scurry away even a small amount of data without relying on the
> disk system is highly desirable.  Think next-boot type information.

Yes.  If that were to be the justifying case and if that was what
the code was implementing I could see the point.

However this point was made in an earlier review.  This point
was already been made, and still this patchset doesn't
include that functionality and it still includes the code
to disable direct hardware access for no seemingly sane
reason.

Eric
