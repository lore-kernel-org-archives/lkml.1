Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXJYRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXJYRMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXJYRMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:12:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbXJYRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:12:07 -0400
Message-ID: <4720CD80.5030106@zytor.com>
Date: Thu, 25 Oct 2007 10:08:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@novell.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com> <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain> <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com> <200710251906.10210.ak@novell.com>
In-Reply-To: <200710251906.10210.ak@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Especially for accessing the real time clock that has a well
>> defined hardware interface going through efi an additional
>> software emulation layer looks like asking for trouble.
> 
> I agree it's pointless for the hardware clock, but EFI 
> also offers services to write some data to the CMOS RAM
> which could be very useful to save oops data over reboot.
> I don't think this can be done safely otherwise 
> without BIOS cooperation.
> 

The ability to scurry away even a small amount of data without relying 
on the disk system is highly desirable.  Think next-boot type information.

	-hpa
