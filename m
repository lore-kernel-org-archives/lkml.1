Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbYAaRho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbYAaRho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYAaRhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:37:37 -0500
Received: from gw.goop.org ([64.81.55.164]:48542 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbYAaRhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:37:36 -0500
Message-ID: <47A20750.8000702@goop.org>
Date: Thu, 31 Jan 2008 09:37:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86.git: wants to build as ia64
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something in current x86.git is making my kernel build as ia64.  I don't 
see any obvious change which might be the cause.

: ezr:pts/6; make oldconfig
make -C /home/jeremy/hg/xen/paravirt/linux O=/home/jeremy/hg/xen/paravirt/linux-i386/. oldconfig
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/toolchain-flags: line 16: ia64-linux-gcc: command not found
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/toolchain-flags: line 17: ia64-linux-objdump: command not found
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/toolchain-flags: line 19: [: !=: unary operator expected
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/toolchain-flags: line 30: ia64-linux-gcc: command not found
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/toolchain-flags: line 31: ia64-linux-readelf: command not found
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/check-gas: line 7: ia64-linux-gcc: command not found
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/check-gas: line 8: ia64-linux-objdump: command not found
/home/jeremy/hg/xen/paravirt/linux/arch/ia64/scripts/check-gas: line 10: [: !=: unary operator expected
/home/jeremy/hg/xen/paravirt/linux/scripts/gcc-version.sh: line 25: ia64-linux-gcc: command not found
/home/jeremy/hg/xen/paravirt/linux/scripts/gcc-version.sh: line 26: ia64-linux-gcc: command not found
  GEN     /home/jeremy/hg/xen/paravirt/linux-i386/Makefile
scripts/kconfig/conf -o arch/ia64/Kconfig
drivers/net/Kconfig:1743:warning: 'select' used by config symbol 'CPMAC' refers to undefined symbol 'FIXED_MII_100_FDX'
drivers/spi/Kconfig:156:warning: 'select' used by config symbol 'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'
.config:12:warning: trying to assign nonexistent symbol GENERIC_CMOS_UPDATE
.config:13:warning: trying to assign nonexistent symbol CLOCKSOURCE_WATCHDOG
.config:14:warning: trying to assign nonexistent symbol GENERIC_CLOCKEVENTS
.config:15:warning: trying to assign nonexistent symbol GENERIC_CLOCKEVENTS_BROADCAST
.config:18:warning: trying to assign nonexistent symbol SEMAPHORE_SLEEPERS
.config:22:warning: trying to assign nonexistent symbol GENERIC_ISA_DMA
.config:25:warning: trying to assign nonexistent symbol GENERIC_HWEIGHT
.config:29:warning: trying to assign nonexistent symbol RWSEM_GENERIC_SPINLOCK
.config:37:warning: trying to assign nonexistent symbol ZONE_DMA32
.config:43:warning: trying to assign nonexistent symbol X86_SMP
.config:44:warning: trying to assign nonexistent symbol X86_32_SMP
...

    J
