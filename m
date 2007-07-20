Return-Path: <linux-kernel-owner+w=401wt.eu-S934103AbXGTQqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbXGTQqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765054AbXGTQoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:44:19 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:51499 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764030AbXGTQoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:44:15 -0400
Message-Id: <20070720164043.523003359@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Fri, 20 Jul 2007 18:40:43 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] m68k: -Werror-implicit-function-declaration fallout
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Andrew,

These patches fix the fallout on m68k of the recent introduction of
-Werror-implicit-function-declaration:
  [1] m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
  [2] netdev: i82596 Ethernet needs <asm/cacheflush.h>
  [3] scsi: wd33c93 needs <asm/irq.h>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

