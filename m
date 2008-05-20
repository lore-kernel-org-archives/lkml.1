Return-Path: <linux-kernel-owner+w=401wt.eu-S1765728AbYETLHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765728AbYETLHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbYETLGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:06:52 -0400
Received: from ozlabs.org ([203.10.76.45]:51597 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbYETLGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:06:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18482.45251.452257.145098@cargo.ozlabs.ibm.com>
Date: Tue, 20 May 2008 21:06:43 +1000
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

to get a collection of small fixes and a defconfig update for
powerpc, plus an update to MAINTAINERS for the Cell port.

Thanks,
Paul.

 MAINTAINERS                            |   23 ++-
 arch/powerpc/boot/.gitignore           |    8 -
 arch/powerpc/boot/Makefile             |    6 +
 arch/powerpc/boot/dts/mpc8377_mds.dts  |   18 ++
 arch/powerpc/configs/chrp32_defconfig  |  164 +++++++++++++---------
 arch/powerpc/configs/g5_defconfig      |  226 +++++++++++++++----------------
 arch/powerpc/configs/iseries_defconfig |  146 +++++++++++++-------
 arch/powerpc/configs/pmac32_defconfig  |  174 +++++++++++++++---------
 arch/powerpc/configs/ppc64_defconfig   |  236 +++++++++++++++-----------------
 arch/powerpc/configs/pseries_defconfig |  224 +++++++++++++++---------------
 arch/powerpc/mm/hash_low_32.S          |    2 
 lib/lmb.c                              |    3 
 12 files changed, 675 insertions(+), 555 deletions(-)

Adrian Bunk (1):
      [POWERPC] powerpc/mm/hash_low_32.S: Remove CVS keyword

Arnd Bergmann (1):
      [POWERPC] Update Cell MAINTAINERS entry, add spufs entry

Kumar Gala (4):
      lmb: Fix compile warning
      [POWERPC] Remove generated files on make clean
      [POWERPC] Update arch/powerpc/boot/.gitignore
      [POWERPC] Fix mpc8377_mds.dts DMA nodes to match spec

Paul Mackerras (1):
      [POWERPC] Update defconfigs for desktop/server systems

