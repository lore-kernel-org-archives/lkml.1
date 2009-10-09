Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbZJICzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbZJICzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 22:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbZJICzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 22:55:17 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56985 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747AbZJICzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 22:55:16 -0400
Date: Fri, 9 Oct 2009 11:53:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.32-rc4
Message-ID: <20091009025344.GB7179@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.32

Which contains:

Kuninori Morimoto (3):
      sh: mach-ecovec24: Add TouchScreen support
      sh: mach-ecovec24: modify 1st MTD area to read only
      sh: mach-ecovec24: Document DS2 switch settings.

Lubomir Rintel (1):
      sh: Build fix: export __movmem

Magnus Damm (2):
      usb: r8a66597-udc unaligned fifo fix
      sh: enable sleep state LEDs on Ecovec24

Matt Fleming (5):
      sh: Don't enable interrupts in the page fault path
      sh: Sprinkle __uses_jump_to_uncached
      sh: Plug PMB alloc memory leak
      sh: Try PMB mapping based on physical address, not mapping size
      sh: Don't allocate smaller sized mappings on every iteration

Paul Mundt (4):
      sh: Handle ioport_map() cases for >= P1SEG addresses.
      sh: Set the default I/O port base to P2SEG.
      sh: magicpanelr2 and dreamcast can use the generic I/O base.
      sh: Disable unaligned kernel access printks by default.

 arch/sh/boards/board-magicpanelr2.c   |    2 -
 arch/sh/boards/mach-dreamcast/setup.c |    2 -
 arch/sh/boards/mach-ecovec24/setup.c  |   63 +++++++++++++++++++-
 arch/sh/kernel/cpu/sh3/entry.S        |    2 -
 arch/sh/kernel/io_generic.c           |    3 +
 arch/sh/kernel/machvec.c              |    3 +
 arch/sh/kernel/sh_ksyms_32.c          |    1 +
 arch/sh/kernel/traps_32.c             |    4 +-
 arch/sh/mm/cache-sh4.c                |    2 +-
 arch/sh/mm/cache-sh7705.c             |    4 +-
 arch/sh/mm/ioremap_32.c               |    2 +-
 arch/sh/mm/pmb.c                      |   37 ++++++++++--
 drivers/usb/gadget/r8a66597-udc.h     |  105 +++++++++++++++++++-------------
 13 files changed, 168 insertions(+), 62 deletions(-)
