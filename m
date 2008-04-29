Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYD2LaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYD2LaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYD2LaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:30:05 -0400
Received: from ozlabs.org ([203.10.76.45]:37867 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbYD2LaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:30:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18455.1713.268188.906051@cargo.ozlabs.ibm.com>
Date: Tue, 29 Apr 2008 21:29:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git master branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do:

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git master

There are 14 commits there that Andrew Morton sent to me to merge,
from Badari Pulavarty (memory hot-remove stuff) and Zhang Wei (RapidIO
patches).  Plus there are 5 other powerpc-related patches: a patch
from me adding a fast endian-switch system call, a patch from Kumar
Gala that lets 32-bit use separate stacks for hard and soft IRQs like
64-bit already does, a build fix from Tony Breeds, a patch from me to
make powerpc build OK if inline doesn't mean __always_inline, and a
thermal driver for one of the last G5 powermac models.

Thanks,
Paul.

Badari Pulavarty (3):
      [POWERPC] Hotplug memory remove notifications for powerpc
      [POWERPC] Update lmb data structures for hotplug memory add/remove
      [POWERPC] Provide walk_memory_resource() for powerpc

Kumar Gala (1):
      [POWERPC] Add IRQSTACKS support on ppc32

Paul Mackerras (2):
      [POWERPC] Add fast little-endian switch system call
      [POWERPC] Use __always_inline for xchg* and cmpxchg*

Tony Breeds (1):
      [POWERPC] Fix building of pmac32 when CONFIG_NVRAM=m

Zhang Wei (11):
      [RAPIDIO] Change RIO function mpc85xx_ to fsl_
      [RAPIDIO] Add RapidIO option to kernel configuration
      [RAPIDIO] Move include/asm-ppc/rio.h to asm-powerpc
      [RAPIDIO] Add RapidIO multi mport support
      [RAPIDIO] Add OF-tree support to RapidIO controller driver
      [RAPIDIO] Auto-probe the RapidIO system size
      [RAPIDIO] Add RapidIO node into MPC8641HPCN dts file
      [RAPIDIO] Add RapidIO node probing into MPC86xx_HPCN board id table
      [RAPIDIO] Add serial RapidIO controller support, which includes MPC8548, MPC8641
      [RAPIDIO] Add RapidIO connection info print out and re-training for broken connections
      [RAPIDIO] Change RapidIO doorbell source and target ID field to 16-bit

Étienne Bersac (1):
      [POWERPC] windfarm: Add PowerMac 12,1 support

