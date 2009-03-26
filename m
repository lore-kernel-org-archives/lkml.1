Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZCZUfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZCZUfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZCZUev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:34:51 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:43423 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbZCZUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:34:50 -0400
Date: Thu, 26 Mar 2009 21:34:46 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [git] m68k
Message-ID: <Pine.LNX.4.64.0903262128080.26468@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hi Linus,

Please pull from

    git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

to receive the m68k-related updates for 2.6.30 below.

Nothing really spectacular, most notable is a new Mac SWIM floppy driver, which
Jens had no problem with going in through the m68k tree.

Thanks!

Geert Uytterhoeven (2):
      MAINTAINERS: Replace dead link to m68k CVS repository by link to new git repository
      m68k: irq_node.handler() should return irqreturn_t

Laurent Vivier (3):
      m68k: Add install target
      m68k: mac - Add a new entry in mac_model to identify the floppy controller type.
      m68k: mac - Add SWIM floppy support

Michael Schmitz (2):
      m68k: section mismatch fixes: DMAsound for Atari
      m68k: section mismatch fixes: Atari SCSI

 MAINTAINERS                         |    2 +-
 arch/m68k/Makefile                  |    3 +
 arch/m68k/include/asm/irq_mm.h      |    3 +-
 arch/m68k/include/asm/macintosh.h   |    7 +
 arch/m68k/install.sh                |   52 ++
 arch/m68k/mac/config.c              |  207 ++++++--
 arch/m68k/mac/via.c                 |    9 +
 drivers/block/Kconfig               |    7 +
 drivers/block/Makefile              |    3 +
 drivers/block/swim.c                |  995 +++++++++++++++++++++++++++++++++++
 drivers/block/swim_asm.S            |  247 +++++++++
 drivers/scsi/atari_NCR5380.c        |    2 +-
 drivers/scsi/atari_scsi.c           |    2 +-
 sound/oss/dmasound/dmasound_atari.c |    4 +-
 14 files changed, 1483 insertions(+), 60 deletions(-)
 create mode 100644 arch/m68k/install.sh
 create mode 100644 drivers/block/swim.c
 create mode 100644 drivers/block/swim_asm.S

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
