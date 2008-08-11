Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYHKLOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYHKLOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYHKLOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:14:08 -0400
Received: from ozlabs.org ([203.10.76.45]:51512 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbYHKLOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:14:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18592.7928.466322.954498@cargo.ozlabs.ibm.com>
Date: Mon, 11 Aug 2008 21:14:00 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

There are some assorted powerpc bugfixes and defconfig updates, plus a
patch to Documentation/feature-removal-schedule.txt from Robert
P. J. Day that removes the section on removing arch/ppc, since that is
done, plus one from me removing include/linux/harrier_defs.h, since it
was only used by code in arch/ppc which is now gone.

Thanks,
Paul.

 Documentation/feature-removal-schedule.txt     |   13 -
 arch/powerpc/boot/dts/warp.dts                 |   22 +
 arch/powerpc/configs/40x/ep405_defconfig       |  207 +++++++++----
 arch/powerpc/configs/40x/kilauea_defconfig     |  196 +++++++++----
 arch/powerpc/configs/40x/makalu_defconfig      |  196 +++++++++----
 arch/powerpc/configs/40x/walnut_defconfig      |  203 +++++++++----
 arch/powerpc/configs/44x/bamboo_defconfig      |  206 +++++++++----
 arch/powerpc/configs/44x/canyonlands_defconfig |  116 +++++--
 arch/powerpc/configs/44x/ebony_defconfig       |  207 +++++++++----
 arch/powerpc/configs/44x/katmai_defconfig      |  259 ++++++++++++-----
 arch/powerpc/configs/44x/rainier_defconfig     |  207 +++++++++----
 arch/powerpc/configs/44x/sam440ep_defconfig    |  109 +++++--
 arch/powerpc/configs/44x/sequoia_defconfig     |  207 +++++++++----
 arch/powerpc/configs/44x/taishan_defconfig     |  208 +++++++++----
 arch/powerpc/configs/44x/virtex5_defconfig     |  100 +++++-
 arch/powerpc/configs/44x/warp_defconfig        |  232 ++++++++++-----
 arch/powerpc/configs/ppc40x_defconfig          |  374 ++++++++++++++++++++----
 arch/powerpc/configs/ppc44x_defconfig          |  375 ++++++++++++++++++++++--
 arch/powerpc/include/asm/mmu-hash64.h          |    2 
 arch/powerpc/kernel/pci-common.c               |   17 +
 arch/powerpc/kernel/rtas.c                     |    5 
 arch/powerpc/mm/hash_utils_64.c                |   63 ++--
 arch/powerpc/mm/init_64.c                      |    9 -
 arch/powerpc/platforms/44x/warp-nand.c         |    2 
 arch/powerpc/platforms/44x/warp.c              |   25 +-
 include/linux/harrier_defs.h                   |  212 --------------
 26 files changed, 2598 insertions(+), 1174 deletions(-)
 delete mode 100644 include/linux/harrier_defs.h

Benjamin Herrenschmidt (2):
      powerpc/pci: Don't keep ISA memory hole resources in the tree
      powerpc/mm: Fix attribute confusion with htab_bolt_mapping()

Josh Boyer (1):
      powerpc/4xx: Update defconfig files for 2.6.27-rc1

Junio C Hamano (1):
      powerpc: Do not ignore arch/powerpc/include

Nathan Fontenot (1):
      powerpc: Zero fill the return values of rtas argument buffer

Paul Mackerras (1):
      powerpc: Remove include/linux/harrier_defs.h

Robert P. J. Day (1):
      powerpc: Delete completed "ppc removal" task from feature removal file

Sean MacLennan (3):
      powerpc/4xx: Cleanup Warp for i2c driver changes.
      powerpc/44x: Warp DTS changes for board updates
      powerpc/44x: Incorrect NOR offset in Warp DTS

Valentine Barshak (1):
      powerpc/44x: Adjust warp-nand resource end address

