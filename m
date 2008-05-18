Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYERTCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYERTCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbYERSyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:14 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:57713 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760890AbYERSyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:03 -0400
Message-Id: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:06 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/18] Updated m68k patches for 2.6.26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here is the updated set of m68k patches for 2.6.26:
  [01] [PATCH] m68k: Convert access_ok() to an inline function
  [02] [PATCH] m68k: Kill CONFIG_FB_DAFB
  [03] [PATCH] m68k: FB_HP300 depends on DIO and doesn't need FB_CFB_FILLRECT
  [04] [PATCH] m68k: Kill CONFIG_WHIPPET_SERIAL
  [05] [PATCH] m68k vme_scc: avoid global namespace pollution
  [06] [PATCH] m68k: Make gcc aware that BUG() does not return
  [07] [PATCH] m68k: Correct jump if not running on HP300
  [08] [PATCH] m68k: macide doesn't check for Mac
  [09] [PATCH] m68k: dnfb doesn't check for Apollo
  [10] [PATCH] m68k: Some network drivers do not check the platform
  [11] [PATCH] m68k: Some input drivers do not check the platform
  [12] [PATCH] m68k: Return -ENODEV if no device is found
  [13] [PATCH] m68k: Q40/Q60 floppy support is broken
  [14] [PATCH] m68k: export m68k_mmutype
  [15] [PATCH] m68k: Prefix ISA type with ISA_TYPE_
  [16] [PATCH] m68k: Correctly handle multi-ISA at runtime
  [17] [PATCH] m68k: Update defconfigs
  [18] [PATCH] m68k: Add multi_defconfig

Changes since last submission:
  [11] Added hunk for drivers/input/keyboard/hilkbd.c
  [14-16] New
  [17-18] Updated

Please apply, thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

