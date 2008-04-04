Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbYDDNNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbYDDNNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762442AbYDDNGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:06:51 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33872 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762434AbYDDNGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:06:50 -0400
Date: Fri, 4 Apr 2008 09:06:49 -0400
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24 still doesn't boot on i486..
Message-ID: <20080404130649.GG24239@csclub.uwaterloo.ca>
References: <47F5EE6A.6080705@msgid.tls.msk.ru> <18422.8628.510177.819697@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18422.8628.510177.819697@harpo.it.uu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 02:40:20PM +0200, Mikael Pettersson wrote:
> Michael Tokarev writes:
>  > Just a follow-up on my earlier bugreport, when
>  > 2.6.23 first come out....
>  > 
>  > 2.6.24 seems to not boot on i486-class hardware.
>  > The machine reboots right after "Booting linux"
>  > message.  2.6.22 was the last worked kernel.
>  > 
>  > The relevant config entries are:
>  > 
>  > CONFIG_TICK_ONESHOT=y
>  > CONFIG_NO_HZ=y
>  > CONFIG_HIGH_RES_TIMERS=y
>  > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
>  > CONFIG_X86_PC=y
>  > CONFIG_M486=y
>  > CONFIG_X86_GENERIC=y
>  > CONFIG_X86_CMPXCHG=y          <-- is it right?
> 
> yes
> 
>  > CONFIG_X86_L1_CACHE_SHIFT=7
>  > CONFIG_X86_XADD=y
>  > CONFIG_X86_PPRO_FENCE=y
>  > CONFIG_X86_F00F_BUG=y
>  > CONFIG_X86_WP_WORKS_OK=y
>  > CONFIG_X86_INVLPG=y
>  > CONFIG_X86_BSWAP=y
>  > CONFIG_X86_POPAD_OK=y
>  > CONFIG_X86_ALIGNMENT_16=y
>  > CONFIG_X86_INTEL_USERCOPY=y
>  > CONFIG_X86_MINIMUM_CPU_FAMILY=4
>  > CONFIG_X86_UP_APIC=y
>  > CONFIG_X86_UP_IOAPIC=y
>  > CONFIG_X86_LOCAL_APIC=y
>  > CONFIG_X86_IO_APIC=y
>  > CONFIG_X86_MCE=y
>  > CONFIG_X86_MCE_NONFATAL=y
>  > CONFIG_X86_MCE_P4THERMAL=y
>  > CONFIG_NOHIGHMEM=y
>  > CONFIG_VMSPLIT_3G=y
>  > 
>  > Compiled with gcc (GCC) 4.2.3 (Debian 4.2.3-2).
>  > 
>  > This email is also a JFYI-style email.  Yesterday
>  > I tried to debug this issue but discovered that the
>  > power unit of that machine failed.  Well, it still
>  > works and the machine boots, but at the same time
>  > it smells like frosted/fried plastic ;)  So I don't
>  > have i486 hardware anymore to test things on...
>  > 
>  > And now I wonder if I'm the only person in this world
>  > with i486 machine... ;)
> 
> Just FYI, 2.6.23, 2.6.24 and 2.6.25-rc6 work fine on my i486DX4.

A DX4 has many features a DX2 does not.  I will try upgrading from
2.6.18 to 2.6.24 on my DX2/66.  It doesn't have any of the CPUID and
other clever enhancements that newer chips have.

> However, it's clear from your .config fragment above that you've
> enabled features that cannot possibly exist on a 486 (APICs and
> MCE for starters) and there may be bugs related to that. I suggest
> trimming your .config and making it 486-specific.

Doesn't APIC and MCE just do nothing if the system doesn't have them?  I
thought normally it did.

-- 
Len Sorensen
