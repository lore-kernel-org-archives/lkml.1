Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYEPAv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYEPAv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYEPAvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:51:48 -0400
Received: from ozlabs.org ([203.10.76.45]:46112 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYEPAvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:51:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18476.55963.847697.493815@cargo.ozlabs.ibm.com>
Date: Fri, 16 May 2008 10:51:39 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

Most of the bulk is in defconfig and device-tree source (.dts) files,
which are effectively documentation.  The change to mpc85xx_mds.c is
adding some fixups to allow ethernet to work on the 8568 MDS board
even if firmware doesn't initialize it properly.  The rest are all
relatively small, well-contained bug and compile fixes.

Thanks,
Paul.

 arch/powerpc/boot/dts/mpc8377_mds.dts        |   27 ++++++
 arch/powerpc/boot/dts/mpc8610_hpcd.dts       |   60 ++++++++++++-
 arch/powerpc/boot/dts/sbc8548.dts            |   94 ++++++++++++++++++++
 arch/powerpc/configs/mpc8610_hpcd_defconfig  |   95 +++++++++++++++++++-
 arch/powerpc/mm/hash_utils_64.c              |   28 ++++++
 arch/powerpc/mm/init_64.c                    |   10 +-
 arch/powerpc/mm/slb.c                        |   16 +++
 arch/powerpc/mm/slb_low.S                    |   16 +++
 arch/powerpc/platforms/85xx/mpc85xx_mds.c    |  121 ++++++++++++++++++++++++++
 arch/powerpc/platforms/85xx/sbc8548.c        |   30 ++++++
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c   |   15 +++
 arch/powerpc/platforms/cell/io-workarounds.c |    6 +
 arch/powerpc/platforms/cell/io-workarounds.h |    6 +
 arch/powerpc/platforms/cell/spufs/file.c     |    1 
 arch/powerpc/platforms/cell/spufs/sched.c    |    2 
 drivers/macintosh/adb.c                      |    2 
 drivers/of/base.c                            |    3 +
 include/asm-powerpc/mmu-hash64.h             |    1 
 include/asm-powerpc/pgtable-ppc64.h          |   10 +-
 include/asm-powerpc/uaccess.h                |    4 -
 20 files changed, 508 insertions(+), 39 deletions(-)

Andy Fleming (2):
      [POWERPC] 85xx: Add 8568 PHY workarounds to board code
      [POWERPC] 85xx: Fix some sparse warnings for 85xx MDS

Anton Vorontsov (3):
      [POWERPC] 86xx: mpc8610_hpcd: use ULI526X driver for on-board ethernet
      [POWERPC] 86xx: mpc8610_hpcd: add support for NOR and NAND flashes
      [POWERPC] 86xx: mpc8610_hpcd: fix second serial port

Benjamin Herrenschmidt (1):
      [POWERPC] vmemmap fixes to use smaller pages

FUJITA Tomonori (1):
      [POWERPC] spufs: Fix compile error

Ishizaki Kou (1):
      [POWERPC] cell: Fix section mismatches in io-workarounds code

Jeremy McNicoll (1):
      [POWERPC] 85xx: SBC8548 - Add flash support and HW Rev reporting

Luke Browning (1):
      [POWERPC] spufs: Fix pointer reference in find_victim

Nate Case (1):
      [POWERPC] Fix uninitialized variable bug in copy_{to|from}_user

Robert P. J. Day (1):
      [POWERPC] macintosh: Replace deprecated __initcall with device_initcall

Timur Tabi (1):
      [POWERPC] Add null pointer check to of_find_property

Zhang Wei (1):
      [POWERPC] 83xx: Enable DMA engine on the MPC8377 MDS board.

