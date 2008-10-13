Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYJMUGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYJMUGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYJMUFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:05:39 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:44951 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYJMUFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:38 -0400
X-Greylist: delayed 2651 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 16:05:38 EDT
Message-Id: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:58:46 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/18] m68k patches for 2.6.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hi Linus,

Here are the m68k patches I had queued up for the 2.6.28 merge window:
  [01] [PATCH] m68k: use bcd2bin/bin2bcd
  [02] [PATCH] m68k: Use new printk() extension %pS to print symbols
  [03] [PATCH] m68k: Put .bss at the end of the data section
  [04] [PATCH] m68k: Add NOTES to init data so it's discarded at boot
  [05] [PATCH] m68k: Reverse platform MMU logic so Sun 3 is last
  [06] [PATCH] m68k: Disable Amiga serial console support if modular
  [07] [PATCH] m68k: Modular Amiga keyboard needs key_maps
  [08] [PATCH] m68k: Remove unused atari_kbd_translate()
  [09] [PATCH] m68k: Define rtc_lock on Atari
  [10] [PATCH] m68k: Add missing dma_sync_single_range_for_{cpu,device}()
  [11] [PATCH] m68k: <asm/pci.h> needs <asm-generic/pci-dma-compat.h>
  [12] [PATCH] HP input: kill warnings due to suseconds_t differences
  [13] [PATCH] m68k: Remove the broken Hades support
  [14] [PATCH] m68k: remove the dead PCI code
  [15] [PATCH] m68k: init_irq_proc depends on CONFIG_PROC_FS
  [16] [PATCH] m68k: Atari SCSI needs NVRAM
  [17] [PATCH] net/rfkill/rfkill-input.c needs <linux/sched.h>
  [18] [PATCH] arch/m68k/mm/kmap.c: introduce missing kfree

All of them have been reviewed before.
All of them (except for the last one) have been braising in linux-next for
a while.

Thanks for applying!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

