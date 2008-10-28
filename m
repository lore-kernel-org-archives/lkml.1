Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYJ1OrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYJ1OrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYJ1OrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:47:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44056 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYJ1OrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:47:13 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.28-rc2
Date: Tue, 28 Oct 2008 16:47:04 +0200
Message-Id: <1225205224-1119-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch @

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/2.6.28

To receive a bunch of kvm fixes.  Most notably, fix the paravirt mmu bug
that prevents booting recent Linux kernels on kvm.

Shortlog, diffstat:

Avi Kivity (1):
      KVM: Future-proof device assignment ABI

Marcelo Tosatti (1):
      KVM: MMU: sync root on paravirt TLB flush

Sheng Yang (1):
      KVM: Fix guest shared interrupt with in-kernel irqchip

Xiantao Zhang (2):
      KVM: ia64: Fix halt emulation logic
      KVM: ia64: Makefile fix for forcing to re-generate asm-offsets.h

 arch/ia64/include/asm/kvm_host.h |    6 ++-
 arch/ia64/kvm/Makefile           |    8 +++-
 arch/ia64/kvm/kvm-ia64.c         |   80 +++++++++++++++++++------------------
 arch/ia64/kvm/kvm_fw.c           |    9 +++-
 arch/ia64/kvm/process.c          |    2 +-
 arch/x86/include/asm/kvm_host.h  |    3 +
 arch/x86/kvm/i8254.c             |   11 ++++-
 arch/x86/kvm/i8254.h             |    1 +
 arch/x86/kvm/mmu.c               |    1 +
 arch/x86/kvm/x86.c               |    6 ++-
 include/linux/kvm.h              |    6 +++
 include/linux/kvm_host.h         |    7 +++-
 virt/kvm/irq_comm.c              |   42 ++++++++++++++++++-
 virt/kvm/kvm_main.c              |   12 ++++--
 14 files changed, 138 insertions(+), 56 deletions(-)
