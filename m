Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbYDUKb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbYDUKb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYDUKaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:06 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37840
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbYDUK37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:29:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/31] KVM updates for the 2.6.26 merge window (part IV, last)
Date: Mon, 21 Apr 2008 13:29:26 +0300
Message-Id: <1208773797-7829-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fourth and final batch of the pending kvm updates.  This one contains the
ppc port in addition to x86 updates.

 Documentation/ioctl-number.txt      |    2 +
 Documentation/powerpc/kvm_440.txt   |   41 ++
 MAINTAINERS                         |    7 +
 arch/ia64/kvm/Kconfig               |    3 +
 arch/ia64/kvm/kvm-ia64.c            |   43 ++-
 arch/powerpc/Kconfig                |    1 +
 arch/powerpc/Kconfig.debug          |    3 +
 arch/powerpc/Makefile               |    1 +
 arch/powerpc/kernel/asm-offsets.c   |   26 ++
 arch/powerpc/kvm/44x_tlb.c          |  224 ++++++++++
 arch/powerpc/kvm/44x_tlb.h          |   91 +++++
 arch/powerpc/kvm/Kconfig            |   43 ++
 arch/powerpc/kvm/Makefile           |   15 +
 arch/powerpc/kvm/booke_guest.c      |  615 ++++++++++++++++++++++++++++
 arch/powerpc/kvm/booke_host.c       |   83 ++++
 arch/powerpc/kvm/booke_interrupts.S |  436 ++++++++++++++++++++
 arch/powerpc/kvm/emulate.c          |  760 +++++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c          |  436 ++++++++++++++++++++
 arch/s390/kvm/Kconfig               |    3 +
 arch/s390/kvm/interrupt.c           |    5 +
 arch/s390/kvm/kvm-s390.c            |   12 +
 arch/x86/kvm/Kconfig                |   11 +
 arch/x86/kvm/Makefile               |    3 +
 arch/x86/kvm/i8254.c                |   13 +-
 arch/x86/kvm/irq.c                  |   15 +
 arch/x86/kvm/irq.h                  |    3 +
 arch/x86/kvm/lapic.c                |   27 +-
 arch/x86/kvm/mmu.c                  |   92 ++---
 arch/x86/kvm/paging_tmpl.h          |   26 +-
 arch/x86/kvm/svm.c                  |  110 ++++--
 arch/x86/kvm/vmx.c                  |   35 ++-
 arch/x86/kvm/x86.c                  |   79 ++++-
 arch/x86/kvm/x86_emulate.c          |   33 +-
 include/asm-ia64/kvm_host.h         |    8 +-
 include/asm-powerpc/kvm.h           |   53 +++-
 include/asm-powerpc/kvm_asm.h       |   55 +++
 include/asm-powerpc/kvm_host.h      |  152 +++++++
 include/asm-powerpc/kvm_para.h      |   38 ++
 include/asm-powerpc/kvm_ppc.h       |   88 ++++
 include/asm-powerpc/mmu-44x.h       |    2 +
 include/asm-x86/kvm.h               |   20 +
 include/asm-x86/kvm_host.h          |   29 +-
 include/linux/kvm.h                 |   71 ++++-
 include/linux/kvm_host.h            |   31 ++
 include/linux/kvm_types.h           |    2 +
 virt/kvm/kvm_main.c                 |  107 +++++-
 virt/kvm/kvm_trace.c                |  276 +++++++++++++
 47 files changed, 4065 insertions(+), 164 deletions(-)
 create mode 100644 Documentation/powerpc/kvm_440.txt
 create mode 100644 arch/powerpc/kvm/44x_tlb.c
 create mode 100644 arch/powerpc/kvm/44x_tlb.h
 create mode 100644 arch/powerpc/kvm/Kconfig
 create mode 100644 arch/powerpc/kvm/Makefile
 create mode 100644 arch/powerpc/kvm/booke_guest.c
 create mode 100644 arch/powerpc/kvm/booke_host.c
 create mode 100644 arch/powerpc/kvm/booke_interrupts.S
 create mode 100644 arch/powerpc/kvm/emulate.c
 create mode 100644 arch/powerpc/kvm/powerpc.c
 create mode 100644 include/asm-powerpc/kvm_asm.h
 create mode 100644 include/asm-powerpc/kvm_host.h
 create mode 100644 include/asm-powerpc/kvm_para.h
 create mode 100644 include/asm-powerpc/kvm_ppc.h
 create mode 100644 virt/kvm/kvm_trace.c

