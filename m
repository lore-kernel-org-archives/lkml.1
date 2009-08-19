Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbZHSKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbZHSKLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZHSKLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:11:30 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59078 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZHSKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:11:30 -0400
Message-ID: <4A8BCFCD.7020301@monstr.eu>
Date: Wed, 19 Aug 2009 12:11:25 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.31-rc7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some bug fixes for Microblaze + defconfig update.

Thank for pulling,
Michal



The following changes since commit df4ecf1524c7793de3121b2d4e5fc6bcc0da3bfb:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git next

Christoph Hellwig (1):
      microblaze: use the generic ack_bad_irq implementation

John Williams (1):
      microblaze: Sane handling of missing timer/intc in device tree

Michal Simek (3):
      microblaze: Enable ppoll syscall
      microblaze: Use klimit instead of _end for memory init
      microblaze: Update Microblaze defconfigs

 arch/microblaze/configs/mmu_defconfig   |   70 ++++++++++++------------
 arch/microblaze/configs/nommu_defconfig |   91 +++++++++++++++++++------------
 arch/microblaze/include/asm/hardirq.h   |    2 -
 arch/microblaze/kernel/intc.c           |    2 +
 arch/microblaze/kernel/irq.c            |    9 ---
 arch/microblaze/kernel/syscall_table.S  |    2 +-
 arch/microblaze/kernel/timer.c          |    2 +
 arch/microblaze/mm/init.c               |    6 +-
 8 files changed, 99 insertions(+), 85 deletions(-)



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
