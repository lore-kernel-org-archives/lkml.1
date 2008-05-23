Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbYEWF7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbYEWF7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765465AbYEWF7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:59:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765264AbYEWF73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:59:29 -0400
Message-ID: <483630AE.3050905@zytor.com>
Date: Thu, 22 May 2008 19:49:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <18482.53246.642835.894623@harpo.it.uu.se>	<4832E705.2010900@zytor.com>	<18482.60491.764019.292031@harpo.it.uu.se>	<20080520175325.GE30034@linux-os.sc.intel.com>	<4834BE39.2000904@zytor.com>	<18485.13663.51624.694435@harpo.it.uu.se>	<20080522205619.GB7998@linux-os.sc.intel.com>	<4835DF64.6080104@zytor.com>	<20080522212920.GC7998@linux-os.sc.intel.com>	<4835E6F5.5010801@zytor.com>	<20080523014855.GA18385@linux-os.sc.intel.com> <20080523021222.8E1A626FA24@magilla.localdomain>
In-Reply-To: <20080523021222.8E1A626FA24@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> hmm.. so the kernel needs to export all the cpuid info (that the kernel
>> enables and supports) to the user through some mechanism then?
> 
> For a cheap interface, we use AT_HWCAP for this.  Unfortunately that only
> covers the first 32 bits of CPUID info.  (For another cheap interface,
> giving all the CPUID bits in the vDSO would be easy.)
> 
> For a clunky interface that already exists and is "simple" to use,
> there is /dev/cpu/0/cpuid now.  I wonder if having a device node and
> opening it too much for applications that consider the vDSO too complex.

I doubt it.

	-hpa

