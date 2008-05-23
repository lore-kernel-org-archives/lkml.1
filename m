Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYEWSJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYEWSJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYEWSJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:09:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:57587 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYEWSJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,531,1204531200"; 
   d="scan'208";a="386593427"
Date: Fri, 23 May 2008 11:09:28 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080523180928.GE18385@linux-os.sc.intel.com>
References: <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522212920.GC7998@linux-os.sc.intel.com> <4835E6F5.5010801@zytor.com> <20080523014855.GA18385@linux-os.sc.intel.com> <20080523021222.8E1A626FA24@magilla.localdomain> <483630AE.3050905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483630AE.3050905@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:49:18PM -0700, H. Peter Anvin wrote:
> Roland McGrath wrote:
> >>hmm.. so the kernel needs to export all the cpuid info (that the kernel
> >>enables and supports) to the user through some mechanism then?
> >
> >For a cheap interface, we use AT_HWCAP for this.  Unfortunately that only
> >covers the first 32 bits of CPUID info.  (For another cheap interface,
> >giving all the CPUID bits in the vDSO would be easy.)
> >
> >For a clunky interface that already exists and is "simple" to use,
> >there is /dev/cpu/0/cpuid now.  I wonder if having a device node and
> >opening it too much for applications that consider the vDSO too complex.
> 
> I doubt it.

Ok. If really needed, they can use this interface aswell. But I don't
see a need for a new system call / other mechanism, just for xsave
purpose. They can rely on cpuid or any other equivalent infrastructure the
kernel provides.

thanks,
suresh
