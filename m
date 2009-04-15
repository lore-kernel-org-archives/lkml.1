Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZDOJaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZDOJaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZDOJaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:30:06 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58819 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZDOJaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:30:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18917.43269.907035.106694@cargo.ozlabs.ibm.com>
Date: Wed, 15 Apr 2009 19:29:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get a collection of bug fixes, a documentation update and a
defconfig update for powerpc.

The commit from Hugh Dickins is not strictly a bugfix, but it is
small, obvious, only affects people using a very specialized embedded
setup (those using 256kB pages on PPC44x embedded systems), and I got
prodded by Andrew Morton about it, so I put it in.

Thanks,
Paul.

 Documentation/powerpc/dts-bindings/fsl/i2c.txt |   46 +++++--
 arch/powerpc/Kconfig                           |    2 
 arch/powerpc/boot/dts/tqm8540.dts              |    4 -
 arch/powerpc/boot/dts/tqm8541.dts              |    4 -
 arch/powerpc/boot/dts/tqm8548-bigflash.dts     |    8 +
 arch/powerpc/boot/dts/tqm8548.dts              |    8 +
 arch/powerpc/boot/dts/tqm8555.dts              |    4 -
 arch/powerpc/boot/dts/tqm8560.dts              |    4 -
 arch/powerpc/configs/85xx/tqm8548_defconfig    |  164 +++++++-----------------
 arch/powerpc/include/asm/futex.h               |   12 +-
 arch/powerpc/include/asm/mmu.h                 |    6 +
 arch/powerpc/include/asm/ppc-opcode.h          |   13 ++
 arch/powerpc/kernel/cputable.c                 |    2 
 arch/powerpc/mm/tlb_nohash.c                   |    1 
 arch/powerpc/mm/tlb_nohash_low.S               |   14 ++
 arch/powerpc/platforms/pseries/dtl.c           |    1 
 arch/powerpc/platforms/pseries/eeh_driver.c    |    2 
 include/linux/fsl_devices.h                    |    4 -
 18 files changed, 136 insertions(+), 163 deletions(-)

Hugh Dickins (1):
      powerpc: Allow 256kB pages with SHMEM

Kumar Gala (3):
      powerpc: Fix tlbilx opcode
      powerpc: Add support for early tlbilx opcode
      powerpc/mm: Fix compile warning

Mike Mason (1):
      powerpc/pseries: Set error_state to pci_channel_io_normal in eeh_report_reset()

Paul Mackerras (1):
      powerpc: Fix data-corrupting bug in __futex_atomic_op

Sachin Sant (1):
      powerpc: pseries/dtl.c should include asm/firmware.h

Wolfgang Grandegger (4):
      powerpc/85xx: TQM85xx: correct address of LM75 I2C device nodes
      powerpc/85xx: TQM8548: use proper phy-handles for enet2 and enet3
      powerpc/85xx: TQM8548: update defconfig
      powerpc: Document new FSL I2C bindings and cleanup

