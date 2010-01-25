Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0AYRVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0AYRVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222Ab0AYRVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:21:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab0AYRVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:21:19 -0500
Date: Mon, 25 Jan 2010 15:20:21 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 2.6.33-rc5
Message-ID: <20100125172021.GA16818@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.33

For the following KVM fixes.

Alexander Graf (1):
      KVM: powerpc: Show timing option only on embedded

Avi Kivity (1):
      KVM: Fix race between APIC TMR and IRR

Christian Borntraeger (1):
      KVM: S390: fix potential array overrun in intercept handling

Davide Libenzi (1):
      eventfd - allow atomic read and waitqueue remove

Marcelo Tosatti (2):
      KVM: properly check max PIC pin in irq route setup
      KVM: MMU: bail out pagewalk on kvm_read_guest error

Michael S. Tsirkin (2):
      KVM: only allow one gsi per fd
      KVM: fix spurious interrupt with irqfd

Sheng Yang (1):
      KVM: x86: Fix host_mapping_level()

Wei Yongjun (2):
      KVM: x86: Fix probable memory leak of vcpu->arch.mce_banks
      KVM: x86: Fix leak of free lapic date in kvm_arch_vcpu_init()


 arch/powerpc/kvm/Kconfig   |    2 +-
 arch/s390/kvm/intercept.c  |    4 +-
 arch/x86/kvm/lapic.c       |   11 +++--
 arch/x86/kvm/mmu.c         |    6 +--
 arch/x86/kvm/paging_tmpl.h |    4 +-
 arch/x86/kvm/x86.c         |    6 ++-
 fs/eventfd.c               |   89 ++++++++++++++++++++++++++++++++++++-------
 include/linux/eventfd.h    |   16 ++++++++
 virt/kvm/eventfd.c         |   18 +++++++-
 virt/kvm/irq_comm.c        |    6 ++-
 10 files changed, 128 insertions(+), 34 deletions(-)

