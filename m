Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYDCTde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYDCTde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbYDCTc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:32:56 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53003
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbYDCTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/35] KVM updates for the 2.6.26 merge window (part II)
Date: Thu,  3 Apr 2008 22:32:15 +0300
Message-Id: <1207251170-5013-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These thirty-five patches comprise the second batch of the updates I have
queued for 2.6.26.  Please review.

 arch/x86/Kconfig                  |    8 +
 arch/x86/kernel/Makefile          |    1 +
 arch/x86/kernel/crash.c           |    3 +-
 arch/x86/kernel/kvm.c             |  247 ++++++++++++++
 arch/x86/kernel/kvmclock.c        |   27 ++
 arch/x86/kernel/reboot.c          |   13 +-
 arch/x86/kernel/setup_32.c        |    1 +
 arch/x86/kernel/setup_64.c        |    2 +
 arch/x86/kvm/Kconfig              |    2 +-
 arch/x86/kvm/Makefile             |    3 +-
 arch/x86/kvm/i8254.c              |  600 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/i8254.h              |   62 ++++
 arch/x86/kvm/irq.c                |    3 +
 arch/x86/kvm/lapic.c              |    8 +-
 arch/x86/kvm/mmu.c                |  426 ++++++++++++++++++++++---
 arch/x86/kvm/paging_tmpl.h        |   46 ++-
 arch/x86/kvm/segment_descriptor.h |   29 --
 arch/x86/kvm/svm.c                |   41 ++-
 arch/x86/kvm/svm.h                |    3 +
 arch/x86/kvm/tss.h                |   59 ++++
 arch/x86/kvm/vmx.c                |   70 +++-
 arch/x86/kvm/x86.c                |  647 +++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86_emulate.c        |    4 +-
 include/asm-x86/kvm.h             |   21 ++
 include/asm-x86/kvm_host.h        |   54 +++-
 include/asm-x86/kvm_para.h        |   32 ++-
 include/asm-x86/reboot.h          |    2 +
 include/linux/kvm.h               |    7 +
 include/linux/kvm_host.h          |   21 +-
 include/linux/kvm_para.h          |   11 +-
 virt/kvm/kvm_main.c               |   78 ++++-
 31 files changed, 2302 insertions(+), 229 deletions(-)
