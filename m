Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYLUPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYLUPCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYLUPCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:02:04 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:48812 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYLUPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:02:00 -0500
Message-Id: <20081221150059.844577615@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 21 Dec 2008 16:00:59 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/6] [patch 0/6] Atari frame buffer fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchsets contains several fixes for the Atari frame buffer device, and
includes a refactoring of the c2p (Chunky-to-Planar) code:
  [1] fbdev: atafb - Fix line length handling
  [2] fbdev: atafb - Fix 16 bpp console
  [3] fbdev: c2p - Cleanups
  [4] fbdev: c2p - Extract common c2p core to c2p_core.h
  [5] fbdev: c2p/atafb - Add support for Atari interleaved bitplanes
  [6] fbdev: c2p - Rename c2p to c2p_planar and correct indentation

If nobody objects, I'd like to push this to Linus via the m68k tree, as the
c2p code is used by m68k drivers (atafb and amifb) only.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

