Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbYKLJeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbYKLJeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYKLJe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:34:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50308 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYKLJe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:34:26 -0500
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.28-rc
Date: Wed, 12 Nov 2008 11:34:15 +0200
Message-Id: <1226482455-21199-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/2.6.28

to receive the current batch of KVM fixes.  These include a fix for a host
oops under heavy guest loads, memory attribute inconsistency fix with
Nehalem processors, a signal handling fix for ia64, and a few minor fixes.

Avi Kivity (2):
      KVM: Require the PCI subsystem
      KVM: Fix pit memory leak if unable to allocate irq source id

Marcelo Tosatti (1):
      KVM: MMU: increase per-vcpu rmap cache alloc size

Rakib Mullick (1):
      x86: KVM guest: fix section mismatch warning in kvmclock.c

Sheng Yang (1):
      KVM: VMX: Set IGMT bit in EPT entry

Xiantao Zhang (2):
      KVM: ia64: Use guest signal mask when blocking
      KVM: ia64: fix vmm_spin_{un}lock for !CONFIG_SMP

 arch/ia64/kvm/Kconfig      |    2 ++
 arch/ia64/kvm/kvm-ia64.c   |   12 ++++++------
 arch/ia64/kvm/vcpu.h       |    5 +++++
 arch/x86/kernel/kvmclock.c |    2 +-
 arch/x86/kvm/Kconfig       |    2 ++
 arch/x86/kvm/i8254.c       |    4 +++-
 arch/x86/kvm/mmu.c         |    2 +-
 arch/x86/kvm/vmx.c         |    3 ++-
 arch/x86/kvm/vmx.h         |    1 +
 9 files changed, 23 insertions(+), 10 deletions(-)
