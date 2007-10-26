Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbXJZJ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbXJZJ3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbXJZJ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:29:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:44424 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbXJZJ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:29:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,332,1188802800"; 
   d="scan'208";a="305911813"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.0.9999.0710261027260.3186@localhost.localdomain>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	 <1193360591.23935.212.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710261027260.3186@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 17:30:02 +0800
Message-Id: <1193391002.23935.300.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 09:27:12.0168 (UTC) FILETIME=[638A3A80:01C817B2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 10:48 +0200, Thomas Gleixner wrote:
> > EFI uses the Windows x86_64 calling convention. The lin2win may be a
> > more general naming convention that can be used for some other code (the
> > NDISwrapper?) in the future. Do you agree?
> 
> I agree not at all. I do not care whether the EFI creators smoked the
> Windows-crackpipe or some other hallucinogen when they decided to use
> this calling convention. We definitely do not want to think about
> NDISwrapper or any other Windows related hackery in the kernel.

OK, I will change the name to something like lin2efi.

> I still do not understand why we need all this EFI hackery at all
> aside of the possible usage for saving a crash dump on FLASH, which we
> could do directly from the kernel as well.

Ask every user to setup a crash dump environment is a bit difficult
because some configuration like reserving memory, loading crash dump
kernel must be done. But saving OOPS information in FLASH via EFI
variable runtime service is quite simple, without configuration
requirement. That is, there could be more bug report with OOPS
information. I think this is useful.

Best Regards,
Huang Ying
