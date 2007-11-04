Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbXKDSoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbXKDSoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXKDSoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:44:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:36280 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXKDSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=s6+lFaJoXkeZ9aSokb/IW7k5OqqWqBXOYcHTIbfiolj7+JD7IBZ6WE1u8RIBG1ccHXKRx+7e0ouPLY6EsoczIXkN2iUsIDZsMyIjo/7ZXZDv1DN1FF89tyg4P/jcEXTDBShXMuQ1tMGoXebmo/8GNbLpUVfFwAozMHaziSlFO78=
Message-ID: <e5bfff550711041044p7c07c42g836461e81a6005a@mail.gmail.com>
Date: Sun, 4 Nov 2007 19:44:04 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: List of possible duplicated include files in include/
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here the number of false positives is overhelming, but perhaps there
are also _real_ duplicated include somewhere in the bunch:

include/acpi/acpi_bus.h:
#include <linux/device.h>

include/asm-alpha/core_cia.h:
#include <asm/io_trivial.h>

include/asm-arm/atomic.h:
#include <asm/system.h>

include/asm-arm/arch-clps711x/hardware.h:
#include <asm/hardware/ep7212.h>

include/asm-arm/arch-clps711x/hardware.h:
#include <asm/hardware/clps7111.h>

include/asm-arm/arch-clps711x/hardware.h:
#include <asm/hardware/ep7212.h>

include/asm-arm/arch-clps711x/hardware.h:
#include <asm/hardware/cs89712.h>

include/asm-arm/arch-clps711x/hardware.h:
#include <asm/hardware/clps7111.h>

include/asm-arm/arch-clps711x/hardware.h:
#include <asm/hardware/ep7212.h>

include/asm-ia64/pgtable.h:
#include <asm/processor.h>

include/asm-m32r/m32r.h:
#include <asm/m32700ut/m32700ut_pld.h>

include/asm-mips/bitops.h:
#include <asm-generic/bitops/fls64.h>

include/asm-mips/tx4938/tx4938.h:
#include <asm/byteorder.h>

include/asm-powerpc/io.h:
#include <asm/io-defs.h>

include/asm-x86/elf.h:
#include <asm/processor.h>

include/asm-x86/msr.h:
#include <linux/errno.h>

include/asm-x86/smp_64.h:
#include <asm/thread_info.h>

include/linux/aio.h:
#include <linux/uio.h>

include/linux/aio.h:
#include <linux/aio_abi.h>

include/linux/atalk.h:
#include <asm/byteorder.h>

include/linux/cgroup.h:
#include <linux/cgroup_subsys.h>

include/linux/icmpv6.h:
#include <linux/skbuff.h>

include/linux/igmp.h:
#include <linux/skbuff.h>

include/linux/udp.h:
#include <linux/types.h>

include/net/ieee80211.h:
#include <linux/wireless.h>
