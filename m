Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbXJZGXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbXJZGXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXJZGXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:23:37 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49205 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXJZGXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:23:36 -0400
Date: Fri, 26 Oct 2007 02:20:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Mikael Starvik <mikael.starvik@axis.com>
cc: linux-kernel@vger.kernel.org, Jesper Nilsson <Jesper.Nilsson@axis.com>
Subject: Re: Upcomming CRIS patches
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668052DE86C@exmail1.se.axis.com>
Message-ID: <Pine.LNX.4.64.0710260217260.25424@localhost.localdomain>
References: <BFECAF9E178F144FAEF2BF4CE739C668052DE86C@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Mikael Starvik wrote:

> Just a heads up that we will now finally start to submit CRIS
> patches. The first patches will make CRIS compile in the official
> tree. Further patches will then add functionality and correct bugs.
>
> A new machine called Artpec-3 will also be added.

just for the sheer heck of it, here's my current list of CRIS-related
"dead" CONFIG variables you may or may not want to toss before
committing to the main tree:

	$ ../find_dead_configs.sh arch/cris

>>>>> ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:38:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:76:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:88:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:107:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:207:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:300:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:334:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:352:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:404:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:414:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/kgdb.c:384:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/kgdb.c:394:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/debugport.c:92:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/debugport.c:169:#elif !defined(CONFIG_ETRAXFS_SIM)
arch/cris/arch-v32/kernel/Makefile:13:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
arch/cris/arch-v32/mm/init.c:68:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/mm/init.c:87:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/mm/init.c:93:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/drivers/axisflashmap.c:294:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/defconfig:71:# CONFIG_ETRAXFS_SIM is not set
include/asm-cris/arch-v32/processor.h:26:#ifndef CONFIG_ETRAXFS_SIM
include/asm-cris/arch-v32/page.h:14:#ifndef CONFIG_ETRAXFS_SIM
>>>>> ETRAX_KGB_PORT2
arch/cris/arch-v32/kernel/irq.c:32:#elif defined(CONFIG_ETRAX_KGB_PORT2)
>>>>> ETRAX_RTC_READONLY
arch/cris/arch-v32/drivers/pcf8563.c:98:#ifdef CONFIG_ETRAX_RTC_READONLY
arch/cris/arch-v32/drivers/pcf8563.c:230:#ifdef CONFIG_ETRAX_RTC_READONLY
arch/cris/arch-v32/drivers/pcf8563.c:286:#endif /* !CONFIG_ETRAX_RTC_READONLY */
arch/cris/arch-v10/drivers/ds1302.c:308:#ifndef CONFIG_ETRAX_RTC_READONLY
arch/cris/arch-v10/drivers/pcf8563.c:90:#ifdef CONFIG_ETRAX_RTC_READONLY
arch/cris/arch-v10/drivers/pcf8563.c:219:#ifdef CONFIG_ETRAX_RTC_READONLY
arch/cris/arch-v10/drivers/pcf8563.c:271:#endif /* !CONFIG_ETRAX_RTC_READONLY */
>>>>> JULIETTE
arch/cris/mm/init.c:63: *  Only map segment 0xa as seg if CONFIG_JULIETTE
arch/cris/arch-v10/kernel/head.S:557:#ifdef CONFIG_JULIETTE
arch/cris/arch-v10/mm/init.c:74:#ifdef CONFIG_JULIETTE
arch/cris/arch-v10/mm/init.c:95:#ifdef CONFIG_JULIETTE
arch/cris/arch-v10/kernel/head.S:119: * * Removed G27 auto-setting when JULIETTE is chosen (need to make this
>>>>> MTD_AMDSTD
arch/cris/arch-v32/drivers/axisflashmap.c:193:#ifdef CONFIG_MTD_AMDSTD
arch/cris/arch-v10/drivers/axisflashmap.c:315:#ifdef CONFIG_MTD_AMDSTD
arch/cris/arch-v10/defconfig:102:CONFIG_MTD_AMDSTD=y
arch/cris/arch-v10/defconfig:148:CONFIG_MTD_AMDSTD=y
arch/cris/defconfig:230:CONFIG_MTD_AMDSTD=y
arch/cris/arch-v32/drivers/Kconfig:366:	select MTD_AMDSTD
arch/cris/arch-v10/drivers/Kconfig:609:	select MTD_AMDSTD

	$ ../find_dead_configs.sh include/asm-cris/

>>>>> ETRAX_ARCH_V32
arch/cris/defconfig:73:# CONFIG_ETRAX_ARCH_V32 is not set
arch/cris/Makefile:18:arch-$(CONFIG_ETRAX_ARCH_V32) := v32
drivers/ide/cris/ide-cris.c:55:#ifdef CONFIG_ETRAX_ARCH_V32
include/asm-cris/etraxgpio.h:37:#ifdef CONFIG_ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:3:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:8:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:16:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:24:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:32:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:40:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:48:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:56:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:120:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:128:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:135:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:144:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:151:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:162:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:171:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:181:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:190:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:204:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:212:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:226:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:234:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:248:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:256:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:270:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:278:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/Kconfig:292:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:3:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:58:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:361:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:378:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:421:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:430:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:448:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:466:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:589:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:601:        depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:616:	depends on ETRAX_ARCH_V32
arch/cris/arch-v32/drivers/Kconfig:623:	depends on ETRAX_ARCH_V32
>>>>> ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:38:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:76:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:88:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:107:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:207:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:300:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:334:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:352:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:404:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/head.S:414:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/kgdb.c:384:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/kgdb.c:394:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/debugport.c:92:#ifdef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/kernel/debugport.c:169:#elif !defined(CONFIG_ETRAXFS_SIM)
arch/cris/arch-v32/kernel/Makefile:13:obj-$(CONFIG_ETRAXFS_SIM) += vcs_hook.o
arch/cris/arch-v32/mm/init.c:68:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/mm/init.c:87:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/mm/init.c:93:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/arch-v32/drivers/axisflashmap.c:294:#ifndef CONFIG_ETRAXFS_SIM
arch/cris/defconfig:71:# CONFIG_ETRAXFS_SIM is not set
include/asm-cris/arch-v32/processor.h:26:#ifndef CONFIG_ETRAXFS_SIM
include/asm-cris/arch-v32/page.h:14:#ifndef CONFIG_ETRAXFS_SIM
>>>>> SHARE_SHLIB_CORE
include/asm-cris/eshlibld.h:44:   Mainly depends on the config macro CONFIG_SHARE_SHLIB_CORE, but it is
include/asm-cris/eshlibld.h:49:     && !defined(CONFIG_SHARE_SHLIB_CORE)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
