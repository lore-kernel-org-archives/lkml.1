Return-Path: <linux-kernel-owner+w=401wt.eu-S932248AbYGQTXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbYGQTXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbYGQTWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:22:44 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:34827 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745AbYGQTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:43 -0400
Message-Id: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:07 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/29] m68k patches for 2.6.27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here are the m68k patches for 2.6.27:
  [01] m68k: remove CVS keywords
  [02] ariadne: use netstats in net_device structure
  [03] m68k: Return -ENODEV if no device is found
  [04] m68k: vmlinux-std/sun3.lds.S cleanup - use PAGE_SIZE macro
  [05] m68k: Allow no CPU/platform type for allnoconfig
  [06] m68k: remove -traditional [RFC patch 4/9] Re: [PATCH] Stringify support commas
  [07] m68k: make multi_defconfig the default defconfig
  [08] m68k: remove AP1000 code
  [09] ZORRO: Replace deprecated __initcall with equivalent device_initcall.
  [10] zorro: use memory_read_from_buffer
  [11] amifb: Register Amiga-specific video modes with sysfs
  [12] atafb: Register Atari-specific video modes with sysfs
  [13] drivers/video/c2p.c: add MODULE_LICENSE
  [14] export amiga_vblank
  [15] export c2p
  [16] m68k/amiga/: possible cleanups
  [17] m68k/atari/debug.c: possible cleanups
  [18] m68k/mac/: possible cleanups
  [19] m68k/q40/config.c: make functions static
  [20] m68k/sun3/: possible cleanups
  [21] m68k: remove stale ARCH_SUN4 #define
  [22] m68k/apollo: Add missing call to apollo_parse_bootinfo()
  [23] m68k/Mac: remove the unused ADB_KEYBOARD option
  [24] m68k/Atari: remove the dead ATARI_SCC{,_DMA} options
  [25] m68k/Apollo: remove the unused APOLLO_ELPLUS option
  [26] arch/m68k/mm/motorola.c: Eliminate NULL test and memset after alloc_bootmem
  [27] arch/m68k/mm/sun3mmu.c: Eliminate NULL test and memset after alloc_bootmem
  [28] dio: use dio_match_device() in dio_bus_match()
  [29] initrd: Fix virtual/physical mix-up in overwrite test

All of them have been submitted for review before. Please apply.

Thanks a lot!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

