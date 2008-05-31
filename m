Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYEaINA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYEaINA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYEaIMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:12:45 -0400
Received: from ozlabs.org ([203.10.76.45]:38112 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYEaIMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:12:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18497.2162.859003.143787@cargo.ozlabs.ibm.com>
Date: Sat, 31 May 2008 18:12:34 +1000
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

to get four more bug-fixes for powerpc (including Ben's patch adding
memory clobbers to the asm for I/O accessors) and a pasemi defconfig
update.

Thanks,
Paul.

 arch/powerpc/boot/dts/mpc8610_hpcd.dts |   10 +-
 arch/powerpc/configs/pasemi_defconfig  |  172 +++++++++++++++++++++-----------
 arch/ppc/kernel/ppc_ksyms.c            |    2 
 drivers/pcmcia/electra_cf.c            |    1 
 include/asm-powerpc/io.h               |   12 +-
 5 files changed, 126 insertions(+), 71 deletions(-)

Benjamin Herrenschmidt (1):
      [POWERPC] Add "memory" clobber to MMIO accessors

Olof Johansson (2):
      electra_cf: Add MODULE_DEVICE_TABLE()
      [POWERPC] pasemi: update pasemi_defconfig, enable electra_cf

Timur Tabi (1):
      [POWERPC] Fix DMA nodes in the MPC8610 HPCD device tree

Tony Breeds (1):
      [POWERPC] Export empty_zero_page and copy_page in arch/ppc

