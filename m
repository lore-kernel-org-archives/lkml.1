Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbZFLBPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbZFLBPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZFLBPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:15:03 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:56227 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756212AbZFLBPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:15:01 -0400
Date: Fri, 12 Jun 2009 11:14:34 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200906120114.n5C1EYNj009715@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch fixes
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull to get fixes for the m68knommu arch.

Regards
Greg



The following changes since commit 769f3e8c384795cc350e2aae27de2a12374d19d4:
  Linus Torvalds (1):
        Merge branch 'printk-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (16):
      m68knommu: fix system reset for ColdFire 527x family
      m68knommu: merge system reset for code ColdFire 523x family
      m68knommu: add CPU reset code for the 5307 ColdFire
      m68knommu: add CPU reset code for the 5407 ColdFire
      m68knommu: add CPU reset code for the 5206 ColdFire
      m68knommu: add CPU reset code for the 5206e ColdFire
      m68knommu: add CPU reset code for the 5249 ColdFire
      m68knommu: add CPU reset code for the 532x ColdFire
      m68knommu: move CPU reset code for the 520x ColdFire into its platform code
      m68knommu: move CPU reset code for the 523x ColdFire into its platform code
      m68knommu: move CPU reset code for the 527x ColdFire into its platform code
      m68knommu: move CPU reset code for the 528x ColdFire into its platform code
      m68knommu: move CPU reset code for the 5272 ColdFire into its platform code
      m68knommu: remove obsolete reset code
      m68knommu: enumerate INIT_THREAD fields properly
      m68knommu: remove unecessary include of thread_info.h in entry.S

Jaswinder Singh Rajput (1):
      headers_check fix: m68k, swab.h

Joe Perches (1):
      arch/m68knommu: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(

 arch/m68k/include/asm/m520xsim.h           |    9 +++
 arch/m68k/include/asm/m523xsim.h           |    9 +++
 arch/m68k/include/asm/m527xsim.h           |    9 +++
 arch/m68k/include/asm/m528xsim.h           |    8 ++
 arch/m68k/include/asm/m532xsim.h           |   12 +++
 arch/m68k/include/asm/processor_no.h       |    8 +-
 arch/m68k/include/asm/swab.h               |    2 +-
 arch/m68k/include/asm/system_no.h          |  107 ----------------------------
 arch/m68knommu/kernel/entry.S              |    1 -
 arch/m68knommu/kernel/setup.c              |   16 ++---
 arch/m68knommu/mm/init.c                   |    4 +-
 arch/m68knommu/platform/5206/config.c      |   18 +++--
 arch/m68knommu/platform/5206e/config.c     |   18 +++--
 arch/m68knommu/platform/520x/config.c      |   15 +++--
 arch/m68knommu/platform/523x/config.c      |   14 ++--
 arch/m68knommu/platform/5249/config.c      |   18 +++--
 arch/m68knommu/platform/5272/config.c      |   18 ++++-
 arch/m68knommu/platform/527x/config.c      |   15 +++--
 arch/m68knommu/platform/528x/config.c      |   13 +++-
 arch/m68knommu/platform/5307/config.c      |   16 +++-
 arch/m68knommu/platform/532x/config.c      |   12 +++-
 arch/m68knommu/platform/5407/config.c      |   16 +++-
 arch/m68knommu/platform/coldfire/vectors.c |    7 --
 23 files changed, 178 insertions(+), 187 deletions(-)
