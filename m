Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbXJZBAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbXJZBAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXJZBAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:00:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:22272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbXJZBAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:00:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,330,1188802800"; 
   d="scan'208";a="358670954"
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
In-Reply-To: <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 09:03:11 +0800
Message-Id: <1193360591.23935.212.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 01:00:21.0955 (UTC) FILETIME=[95A3F930:01C8176B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 18:09 +0200, Thomas Gleixner wrote:
> > EFI runtime
> > services initialization are implemented in efi.c. Some x86_64
> > specifics are worth noting here. On x86_64, parameters passed to UEFI
> > firmware services need to follow the UEFI calling convention. For this
> > purpose, a set of functions named lin2win<x> (<x> is the number of
> > parameters) are implemented. EFI function calls are wrapped before
> > calling the firmware service.
> 
> Why needs this to be called lin2win? We do not call Windows, we call
> EFI services, so please use a naming convention which is related to
> the functionality of the code.
> 
> > + *
> > + *  Function calling ABI conversion from SYSV to Windows for x86_64
> 
> Again, these are wrappers to access EFI and not Windows.

EFI uses the Windows x86_64 calling convention. The lin2win may be a
more general naming convention that can be used for some other code (the
NDISwrapper?) in the future. Do you agree?

Best Regards,
Huang Ying
