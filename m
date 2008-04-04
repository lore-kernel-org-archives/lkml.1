Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbYDDNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbYDDNIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbYDDNBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:01:36 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51843 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761111AbYDDNBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:01:34 -0400
Date: Fri, 4 Apr 2008 09:01:33 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24 still doesn't boot on i486..
Message-ID: <20080404130133.GF24239@csclub.uwaterloo.ca>
References: <47F5EE6A.6080705@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F5EE6A.6080705@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 01:01:30PM +0400, Michael Tokarev wrote:
> Just a follow-up on my earlier bugreport, when
> 2.6.23 first come out....
> 
> 2.6.24 seems to not boot on i486-class hardware.
> The machine reboots right after "Booting linux"
> message.  2.6.22 was the last worked kernel.
> 
> The relevant config entries are:
> 
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_X86_PC=y
> CONFIG_M486=y
> CONFIG_X86_GENERIC=y
> CONFIG_X86_CMPXCHG=y          <-- is it right?
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_XADD=y
> CONFIG_X86_PPRO_FENCE=y
> CONFIG_X86_F00F_BUG=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_ALIGNMENT_16=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_X86_UP_APIC=y
> CONFIG_X86_UP_IOAPIC=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_NONFATAL=y
> CONFIG_X86_MCE_P4THERMAL=y
> CONFIG_NOHIGHMEM=y
> CONFIG_VMSPLIT_3G=y
> 
> Compiled with gcc (GCC) 4.2.3 (Debian 4.2.3-2).
> 
> This email is also a JFYI-style email.  Yesterday
> I tried to debug this issue but discovered that the
> power unit of that machine failed.  Well, it still
> works and the machine boots, but at the same time
> it smells like frosted/fried plastic ;)  So I don't
> have i486 hardware anymore to test things on...
> 
> And now I wonder if I'm the only person in this world
> with i486 machine... ;)

I have one that works flawlessly. :)  15 years of mostly 24/7 operation
and still going.  The last 9 years has been as a
firewall/router/fileserver.

-- 
Len Sorensen
