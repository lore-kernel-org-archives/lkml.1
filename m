Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZBJFEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZBJFEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZBJFD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:03:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:56764 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZBJFD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:03:57 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 16:03:12 +1100
Message-Id: <1234242192.31963.472.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

A few powerpc bits for you for 2.6.29. A few bug and regression fixes
(after this pull, it will be regressions only), a couple of board
device tree updates and some trivialities such as build breakage with
random config options due to missing includes.

Among others, this should solve the regressions with X being broken
on PowerMacs due to the legacy_mem files in sysfs returning an error on
mmap.

The following changes since commit 4c098bcd55fad34dcf224bf8343db6a9ac58fc68:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../mason/btrfs-unstable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Ananth N Mavinakayanahalli (1):
      powerpc: Don't emulate mr. instructions

Anton Vorontsov (2):
      powerpc/83xx: Fix missing #{address,size}-cells in mpc8313erdb.dts
      powerpc/83xx: Fix TSEC0 workability on MPC8313E-RDB boards

Benjamin Herrenschmidt (1):
      powerpc/pci: mmap anonymous memory when legacy_mem doesn't exist

Julia Lawall (1):
      arch/powerpc: Eliminate double sizeof

Kumar Gala (1):
      powerpc/fsl-booke: Fix mapping functions to use phys_addr_t

Michael Neuling (3):
      powerpc/83xx: Build breakage for CONFIG_PM but no CONFIG_SUSPEND
      powerpc/cell: Add missing #include for oprofile
      powerpc: Add missing sparsemem.h include

Steven Rostedt (1):
      powerpc/ftrace: Fix math to calculate offset in TOC

paulfax (1):
      powerpc/cpm2: Fix set interrupt type

 arch/powerpc/boot/dts/mpc8313erdb.dts           |   11 ++++-------
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig |    2 +-
 arch/powerpc/kernel/ftrace.c                    |    5 +++--
 arch/powerpc/kernel/pci-common.c                |   17 +++++++++++++++--
 arch/powerpc/lib/sstep.c                        |    2 ++
 arch/powerpc/mm/fsl_booke_mmu.c                 |    4 ++--
 arch/powerpc/mm/pgtable_32.c                    |    4 ++--
 arch/powerpc/oprofile/cell/spu_profiler.c       |    1 +
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c    |    2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c |    1 +
 arch/powerpc/sysdev/cpm2_pic.c                  |    2 +-
 arch/powerpc/sysdev/ipic.c                      |    2 +-
 12 files changed, 34 insertions(+), 19 deletions(-)


