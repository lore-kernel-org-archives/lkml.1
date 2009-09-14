Return-Path: <linux-kernel-owner+w=401wt.eu-S933774AbZINUwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbZINUwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbZINUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:52:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43236 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbZINUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:52:31 -0400
Date: Mon, 14 Sep 2009 13:51:44 -0700
Message-Id: <200909142051.n8EKpiOM017912@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86/txt for v2.6.32
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Joseph Cihula <joseph.cihula@intel.com>,
       Shane Wang <shane.wang@intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Mon, 14 Sep 2009 13:51:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 326ba5010a5429a5a528b268b36a5900d4ab0eba:
  Linus Torvalds (1):
        Linux 2.6.31-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-txt-for-linus

Arnaldo Carvalho de Melo (1):
      x86, intel_txt: Fix typos in Kconfig help

H. Peter Anvin (3):
      x86, intel_txt: tboot.c needs <asm/fixmap.h>
      x86, intel_txt: Factor out the code for S3 setup
      x86, intel_txt: Handle ACPI_SLEEP without X86_TRAMPOLINE

Ingo Molnar (1):
      Merge commit 'v2.6.31-rc8' into x86/txt

Joseph Cihula (4):
      x86, intel_txt: Intel TXT boot support
      x86, intel_txt: Intel TXT reboot/halt shutdown support
      x86, intel_txt: Intel TXT Sx shutdown support
      intel_txt: Force IOMMU on for Intel TXT launch

Shane Wang (1):
      x86, intel_txt: clean up the impact on generic code, unbreak non-x86

 Documentation/intel_txt.txt      |  210 ++++++++++++++++++
 Documentation/x86/zero-page.txt  |    1 +
 arch/x86/Kconfig                 |    4 +
 arch/x86/include/asm/bootparam.h |    3 +-
 arch/x86/include/asm/fixmap.h    |    3 +
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/reboot.c         |    7 +
 arch/x86/kernel/setup.c          |    3 +
 arch/x86/kernel/smpboot.c        |    2 +
 arch/x86/kernel/tboot.c          |  447 ++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/hwsleep.c    |    3 +
 drivers/pci/dmar.c               |    7 +
 drivers/pci/intel-iommu.c        |   17 ++-
 include/linux/tboot.h            |  162 ++++++++++++++
 kernel/cpu.c                     |    1 +
 security/Kconfig                 |   30 +++
 16 files changed, 898 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/intel_txt.txt
 create mode 100644 arch/x86/kernel/tboot.c
 create mode 100644 include/linux/tboot.h
