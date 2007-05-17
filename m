Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXEQMfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXEQMfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXEQMez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:34:55 -0400
Received: from gherkin.frus.com ([192.158.254.49]:58062 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbXEQMey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:34:54 -0400
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
In-Reply-To: <20070517060810.GK30166@redhat.com> "from Dave Jones at May 17,
 2007 02:08:10 am"
To: Dave Jones <davej@redhat.com>
Date: Thu, 17 May 2007 07:34:49 -0500 (CDT)
CC: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070517123449.9FC11DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, May 16, 2007 at 11:36:46PM -0500, Bob Tracy wrote:
>  > Dave Jones wrote:
>  > > Bob, does this patch make it boot again for you?
>  > 
>  > NAK.  No difference.  Identical panic message.  (Yes, I double-checked
>  > to make sure I was booting the patched kernel :-)).
> 
> Hmm, odd.
> Does reverting the patch that Chuck fingered fix it? 

ACK.  I'm running 2.6.22-rc1 minus Joachim's patch as I type this.

Anticipating the question, here's the "Processor type and features"
section from "linux/.config":

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22-rc1
# Sun May 13 00:29:57 2007
#
(...)
#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
CONFIG_MK6=y
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_MODEL=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
