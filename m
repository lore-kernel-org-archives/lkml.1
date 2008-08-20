Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYHTGbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYHTGbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYHTGbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:31:06 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:15341 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbYHTGbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:31:04 -0400
Date: Wed, 20 Aug 2008 15:30:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.27-rc4
Message-ID: <20080820063055.GA14602@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.27

Which contains:

Adrian Bunk (1):
      fix SH7705_CACHE_32KB compilation

Magnus Damm (5):
      sh: remove MSTPCR defines from Migo-R header file
      input: migor_ts compile and detection fix
      sh: export sh7723 VEU as VEU2H
      sh: select memchunk size using kernel cmdline
      video: export sh_mobile_lcdc panel size

Nobuhiro Iwamatsu (3):
      sh: Add support sh_eth to sh7763rdp board
      sh: Add support sh7760fb to sh7763rdp board
      sh: Update sh7763rdp defconfig

Paul Mundt (2):
      sh: mach-x3proto: Fix up smc91x platform data.
      sh: Disable 64kB hugetlbpage size when using 64kB PAGE_SIZE.

Takashi YOSHII (2):
      binfmt_flat: Stub in a FLAT_PLAT_INIT().
      sh: Provide a FLAT_PLAT_INIT() definition.

Yoshinori Sato (1):
      sh: Don't export __{s,u}divsi3_i4i from SH-2 libgcc.

 arch/sh/boards/board-ap325rxa.c          |    4 +
 arch/sh/boards/mach-migor/setup.c        |    8 ++
 arch/sh/boards/mach-sh7763rdp/setup.c    |   84 +++++++++++++++++++++-
 arch/sh/boards/mach-x3proto/setup.c      |   10 +++-
 arch/sh/configs/sh7763rdp_defconfig      |  113 +++++++++++++++++++++++++----
 arch/sh/include/asm/flat.h               |    7 ++
 arch/sh/include/asm/migor.h              |    3 -
 arch/sh/include/asm/sh_mobile_lcdc.h     |    6 ++
 arch/sh/include/cpu-sh3/cpu/cacheflush.h |   10 +++
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c   |    4 +-
 arch/sh/kernel/sh_ksyms_32.c             |    4 +-
 arch/sh/mm/Kconfig                       |    2 +
 arch/sh/mm/consistent.c                  |   27 +++++++
 drivers/input/touchscreen/migor_ts.c     |   11 +++-
 drivers/video/sh_mobile_lcdcfb.c         |    2 +
 fs/binfmt_flat.c                         |    4 +-
 16 files changed, 271 insertions(+), 28 deletions(-)
