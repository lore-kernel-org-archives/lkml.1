Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab0CODgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:36:38 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51956 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0CODgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:36:33 -0400
Date: Mon, 15 Mar 2010 12:35:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] genesis updates for 2.6.34-rc2
Message-ID: <20100315033537.GA14529@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/genesis-2.6.git

Which contains:

Magnus Damm (8):
      ARM: mach-shmobile: G3EVM KEYSC platform data
      ARM: mach-shmobile: G3EVM FLCTL platform data
      mtd: enable sh_flctl on SH-Mobile ARM
      ARM: mach-shmobile: sh7367 SDHI vector merge
      ARM: mach-shmobile: sh7377 SDHI vector merge
      ARM: mach-shmobile: sh7372 SDHI vector merge
      ARM: mach-shmobile: ap4evb SDHI0 platform data V2
      video: enable sh_mobile_lcdc on SH-Mobile ARM

NISHIMOTO Hiroki (1):
      ARM: mach-shmobile: G4EVM KEYSC platform data

 arch/arm/mach-shmobile/board-ap4evb.c |   32 +++++++++
 arch/arm/mach-shmobile/board-g3evm.c  |  122 +++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/board-g4evm.c  |   57 +++++++++++++++
 arch/arm/mach-shmobile/clock-sh7367.c |    7 ++
 arch/arm/mach-shmobile/intc-sh7367.c  |   46 ++++++------
 arch/arm/mach-shmobile/intc-sh7372.c  |   46 ++++++------
 arch/arm/mach-shmobile/intc-sh7377.c  |   36 +++++-----
 drivers/mtd/nand/Kconfig              |    2 +-
 drivers/video/Kconfig                 |    2 +-
 9 files changed, 285 insertions(+), 65 deletions(-)
