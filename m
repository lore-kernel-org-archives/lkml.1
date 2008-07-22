Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYGVThg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYGVThg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYGVTh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:37:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48511 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYGVTh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:37:26 -0400
Subject: [git pull] x86: declaration fixes
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf8
Date: Wed, 23 Jul 2008 01:06:22 +0530
Message-Id: <1216755382.16481.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Hello Ingo,

Here is updated patches for x86-tip.

The following changes since commit a099a9b18ab434594bb01ed920e8c58574203fa9:
  Ingo Molnar (1):
        Merge branch 'out-of-tree'

are available in the git repository at:

  git://git.infradead.org/users/jaswinder/linux-2.6-tip.git master

Jaswinder Singh (8):
      x86: apic_XX.c declare functions before they get used
      x86: vm86_32.c declare functions before they get used
      x86: mm/init_XX.c declare functions before they get used
      x86: mm/fault.c declare do_page_fault before they get used
      x86: mm/ioremap.c declare early_ioremap_debug and early_ioremap_nested as static
      x86: mm/pageattr.c declare arch_report_meminfo before they get used
      x86: mm/pgtable_32.c declare set_pmd_pfn before they get used
      x86: mach-default/setup.c declare no_broadcast before they get used

 arch/x86/mach-default/setup.c |    4 +++-
 arch/x86/mm/fault.c           |    3 +--
 arch/x86/mm/init_32.c         |    1 +
 arch/x86/mm/ioremap.c         |    4 ++--
 include/asm-x86/apic.h        |    5 +++++
 include/asm-x86/hw_irq.h      |   10 ++++++++++
 include/asm-x86/page_32.h     |    1 +
 include/asm-x86/page_64.h     |    1 +
 include/asm-x86/pgtable.h     |    2 ++
 include/asm-x86/pgtable_32.h  |    1 +
 include/asm-x86/syscalls.h    |    5 ++++-
 include/asm-x86/traps.h       |    4 ++++
 12 files changed, 35 insertions(+), 6 deletions(-)


