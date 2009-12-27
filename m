Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZL0RVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZL0RVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 12:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZL0RVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 12:21:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZL0RVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 12:21:46 -0500
Date: Sun, 27 Dec 2009 15:21:05 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 2.6.33-rc2
Message-ID: <20091227172105.GA8008@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.33

For the following KVM fixes.

Alexander Graf (1):
      KVM: powerpc: Fix mtsrin in book3s_64 mmu

Heiko Carstens (1):
      KVM: get rid of kvm_create_vm() unused label warning on s390

Jan Kiszka (1):
      KVM: x86: Extend KVM_SET_VCPU_EVENTS with selective updates

Marcelo Tosatti (2):
      KVM: MMU: remove prefault from invlpg handler
      KVM: LAPIC: make sure IRR bitmap is scanned after vm load

Sheng Yang (1):
      KVM: Fix possible circular locking in kvm_vm_ioctl_assign_device()

Tony Luck (1):
      KVM: ia64: fix build breakage due to host spinlock change

 Documentation/kvm/api.txt        |   10 +++++++++-
 arch/ia64/kvm/vcpu.h             |    9 ++++++---
 arch/ia64/kvm/vmm.c              |    4 ++--
 arch/ia64/kvm/vtlb.c             |    2 +-
 arch/powerpc/kvm/book3s_64_mmu.c |   22 +++++++++++++++++++++-
 arch/x86/include/asm/kvm.h       |    4 ++++
 arch/x86/kvm/lapic.c             |    1 +
 arch/x86/kvm/paging_tmpl.h       |   18 ------------------
 arch/x86/kvm/x86.c               |   12 ++++++++----
 virt/kvm/assigned-dev.c          |    6 +++---
 virt/kvm/kvm_main.c              |    5 ++++-
 11 files changed, 59 insertions(+), 34 deletions(-)

