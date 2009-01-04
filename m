Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZADQeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZADQeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZADQem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:34:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZADQel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:34:41 -0500
Subject: [PATCH -tip 0/7] x86 rename all fields mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 21:48:10 +0530
Message-Id: <1231085890.5517.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6b03a9912ce53af2d94621e8ac2ef217676db70c:
  Ingo Molnar (1):
        Merge branch 'x86/cleanups'

Ingo Molnar (1):
      Merge branch 'x86/cleanups'

Jaswinder Singh Rajput (7):
      x86: rename all fields of mpc_ioapic mpc_X to X
      x86: rename all fields of mpc_lintsrc mpc_X to X
      x86: rename all fields of mpc_intsrc mpc_X to X
      x86: rename all fields of mpc_cpu mpc_X to X
      x86: rename all fields of mpc_bus mpc_X to X
      x86: rename all fields of mpc_oemtable oem_X to X
      x86: rename all fields of mpc_table mpc_X to X

Jaswinder Singh Rajput (1):
      x86: irqinit_64.c init_ISA_irqs should be static

 arch/x86/include/asm/mpspec_def.h |   88 +++++++-------
 arch/x86/kernel/irqinit_64.c      |    2 +-
 arch/x86/kernel/mpparse.c         |  251 ++++++++++++++++++-------------------
 arch/x86/kernel/numaq_32.c        |   27 ++--
 arch/x86/kernel/visws_quirks.c    |   28 ++---
 arch/x86/mach-generic/es7000.c    |    4 +-
 6 files changed, 197 insertions(+), 203 deletions(-)


