Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZJAGQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZJAGQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZJAGQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:16:42 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:43733 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752674AbZJAGQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:16:41 -0400
Date: Thu, 1 Oct 2009 16:16:04 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200910010616.n916G4O4019086@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch fixes
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull to get m68knommu arch bug fixes.

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

The pt_regs rename fix is important, the other couple are minor fixups.

Thanks
Greg




The following changes since commit 17d857be649a21ca90008c6dc425d849fa83db5c:
  Linus Torvalds (1):
        Linux 2.6.32-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (1):
      m68knommu: fix rename of pt_regs offset defines breakage

Huang Weiyi (1):
      m68knommu: remove duplicated #include

Lennart Sorensen (1):
      m68knommu: show KiB rather than pages in "Freeing initrd memory:" message

 arch/m68knommu/kernel/asm-offsets.c      |   28 +++++++++++++-------------
 arch/m68knommu/kernel/entry.S            |    6 ++--
 arch/m68knommu/mm/init.c                 |    2 +-
 arch/m68knommu/platform/5206e/config.c   |    1 -
 arch/m68knommu/platform/68328/entry.S    |   32 +++++++++++++++---------------
 arch/m68knommu/platform/68360/entry.S    |   16 +++++++-------
 arch/m68knommu/platform/coldfire/entry.S |   20 +++++++++---------
 7 files changed, 52 insertions(+), 53 deletions(-)
