Return-Path: <linux-kernel-owner+w=401wt.eu-S1764954AbXHLJoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764954AbXHLJoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXHLJnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:43:43 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:55950 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbXHLJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:43:41 -0400
Message-Id: <20070812094050.522858761@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:40:50 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] m68k patches for 2.6.23-rc2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here are a few m68k-specific patches for 2.6.23-rc2:
   [1] m68k: <asm/page.h> needs <linux/compiler.h>
   [2] m68k: Kill superfluous extern
   [3] m68k: Remove unnecessary m68k_memoffset export and init
   [4] remove dead code in via-pmu68k
   [5] m68k: Use _AC() instead of #ifdef __ASSEMBLY__
   [6] m68k: Enable arbitary speed tty support
   [7] m68k: Don't include RODATA into text segment
   [8] m68k: Fix a few hickups in drivers/scsi/Kconfig
   [9] zorro: Make sysfs `config' attribute read-only
  [10] m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible

Please apply, thanks!

Andrew: I know #10 is already in your tree, but as its omission breaks the m68k
build for Macs, I'm sending it to Linus directly.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

