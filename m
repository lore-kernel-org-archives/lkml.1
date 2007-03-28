Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXC1RdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXC1RdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXC1RdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:33:12 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50000 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010AbXC1RdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:33:11 -0400
Date: Wed, 28 Mar 2007 19:33:10 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2
Message-ID: <20070328173310.GA4682@rhlx01.hs-esslingen.de>
References: <20070326211627.c681af3b.akpm@linux-foundation.org> <20070328170214.GA13044@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328170214.GA13044@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 28, 2007 at 07:02:14PM +0200, Andreas Mohr wrote:
> Hi,
> 
> On Mon, Mar 26, 2007 at 09:16:27PM -0800, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/
> > 
> > 
> > - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
> >   scheduler has been added.
> 
> OOPS (hand-pasted), happens on roughly 85% of bootups, didn't seem to
> occur during my several previous 2.6.21-rc4-mm1 bootups:

Still happens after having added just-published RSDL fixup patch and
reinstalled resulting kernel package.

.config diff between -rc4-mm1 and -rc5-mm1 is negligible.
Interesting items in current .config:
CONFIG_SWAP_PREFETCH=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RT_MUTEXES=y
CONFIG_TICK_ONESHOT=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_ADAPTIVE_READAHEAD=y
CONFIG_HZ=250
CONFIG_X86_PM_TIMER=y
# CONFIG_CPU_IDLE is not set
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_RTC=y

Thanks,

Andreas Mohr
