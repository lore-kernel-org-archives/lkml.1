Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZAGMA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZAGMA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZAGMAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:00:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:47335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZAGMAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:00:12 -0500
Subject: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 17:26:08 +0530
Message-Id: <1231329368.17961.29.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are first set of patches for removing NON-SMP data from smp.h as suggested by Ingo.

The following changes since commit b97d41dd7df418cacfa01e399d35927bbdff600f:
  Ingo Molnar (1):
        Merge branch 'out-of-tree'

Jaswinder Singh Rajput (7):
      x86: smp.h remove obsolete function declaration
      x86: smp.h move zap_low_mappings declartion to tlbflush.h
      x86: smp.h move prefill_possible_map declartion to cpu.h
      x86: smp.h move stack_processor_id declartion to cpu.h
      x86: smp.h move safe_smp_processor_id declartion to cpu.h
      x86: smp.h move cpu_physical_id declartion to cpu.h
      x86: smp.h move boot_cpu_id declartion to cpu.h

 arch/x86/include/asm/cpu.h      |   21 +++++++++++++++++++++
 arch/x86/include/asm/smp.h      |   19 -------------------
 arch/x86/include/asm/tlbflush.h |    2 ++
 arch/x86/kernel/cpu/common.c    |    2 +-
 arch/x86/kernel/io_apic.c       |    1 +
 arch/x86/kernel/setup.c         |    2 +-
 arch/x86/kernel/smpboot.c       |    1 -
 arch/x86/mach-voyager/setup.c   |    1 +
 arch/x86/mm/init_32.c           |    1 -
 drivers/pci/intr_remapping.c    |    1 +
 10 files changed, 28 insertions(+), 23 deletions(-)

Thanks
--
JSR

