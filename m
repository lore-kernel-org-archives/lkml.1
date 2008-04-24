Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbYDXSe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbYDXSe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbYDXSeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:17 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:55470 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYDXSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:14 -0400
Message-Id: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:40 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/15] m68k patches for 2.6.26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here are some m68k patches for 2.6.26:
  [01] m68k: Convert access_ok() to an inline function
  [02] m68k: Kill CONFIG_FB_DAFB
  [03] m68k: FB_HP300 depends on DIO and doesn't need FB_CFB_FILLRECT
  [04] m68k: Kill CONFIG_WHIPPET_SERIAL
  [05] m68k vme_scc: avoid global namespace pollution
  [06] m68k: Make gcc aware that BUG() does not return
  [07] m68k: Correct jump if not running on HP300
  [08] m68k: macide doesn't check for Mac
  [09] m68k: dnfb doesn't check for Apollo
  [10] m68k: Some network drivers do not check the platform
  [11] m68k: Some input drivers do not check the platform
  [12] m68k: Return -ENODEV if no device is found
  [13] m68k: Q40/Q60 floppy support is broken
  [14] m68k: Update defconfigs
  [15] m68k: Add multi_defconfig

Nothing controversial, so please apply, thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

