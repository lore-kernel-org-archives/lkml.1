Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbXHOJvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbXHOJvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbXHOJt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:49:59 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:60942 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbXHOJtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:55 -0400
Message-Id: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:39 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] m68k patches for 2.6.23-rc3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here are a few m68k-specific patches for 2.6.23-rc3:
   [1] m68k: <asm/page.h> needs <linux/compiler.h>
   [2] m68k: Don't include RODATA into text segment
   [3] m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
   [4] m68k: Kill superfluous extern
   [5] m68k: Remove unnecessary m68k_memoffset export and init
   [6] remove dead code in via-pmu68k
   [7] m68k: Use _AC() instead of #ifdef __ASSEMBLY__
   [8] m68k: Enable arbitary speed tty support
   [9] m68k: Fix a few hickups in drivers/scsi/Kconfig
  [10] zorro: Make sysfs `config' attribute read-only

The first 3 are critical, as they fix build errors for some configs.

Please apply, thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

