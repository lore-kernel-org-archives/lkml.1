Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbXJZCJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbXJZCJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXJZCJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:09:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:49103 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbXJZCJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,330,1188802800"; 
   d="scan'208";a="186578456"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <m17ilb5cfv.fsf@ebiederm.dsl.xmission.com>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	 <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	 <200710251906.10210.ak@novell.com> <4720CD80.5030106@zytor.com>
	 <m17ilb5cfv.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 10:12:18 +0800
Message-Id: <1193364738.23935.246.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 02:09:29.0474 (UTC) FILETIME=[3DC12620:01C81775]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 11:30 -0600, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> > Andi Kleen wrote:
> >>> Especially for accessing the real time clock that has a well
> >>> defined hardware interface going through efi an additional
> >>> software emulation layer looks like asking for trouble.
> >>
> >> I agree it's pointless for the hardware clock, but EFI also offers services to
> >> write some data to the CMOS RAM
> >> which could be very useful to save oops data over reboot.
> >> I don't think this can be done safely otherwise without BIOS cooperation.
> >>
> >
> > The ability to scurry away even a small amount of data without relying on the
> > disk system is highly desirable.  Think next-boot type information.
> 
> Yes.  If that were to be the justifying case and if that was what
> the code was implementing I could see the point.
> 
> However this point was made in an earlier review.  This point
> was already been made, and still this patchset doesn't
> include that functionality and it still includes the code
> to disable direct hardware access for no seemingly sane
> reason.

The EFI variable runtime service is included in this patchset.

The EFI time runtime service is selectable via kernel command line
parameter now. If it is desired, it can be disabled by default, and only
enabled if specified in kernel command line parameter. I think the time
runtime service may be useful if the underlying hardware is changed
silently by some vendor.

Best Regards,
Huang Ying
