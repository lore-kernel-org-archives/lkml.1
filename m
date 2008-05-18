Return-Path: <linux-kernel-owner+w=401wt.eu-S1764080AbYERM3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764080AbYERM3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYERMPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:15:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:31185
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbYERMPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:15:31 -0400
Message-ID: <48301DE1.7040006@qumranet.com>
Date: Sun, 18 May 2008 15:15:29 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM Updates for 2.6.26-rc2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Sun, 18 May 2008 15:15:29 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git 
kvm-updates-2.6.26

To receive the following kvm fixes for 2.6.26-rc2:

Avi Kivity (2):
      KVM: x86 emulator: fix writes to registers with modrm encodings
      KVM: Update MAINTAINERS for new mailing lists

Heiko Carstens (1):
      s390: KVM guest: fix compile error

Marcelo Tosatti (3):
      KVM: PIT: take inject_pending into account when emulating hlt
      KVM: Fix kvm_vcpu_block() task state race
      KVM: LAPIC: ignore pending timers if LVTT is disabled

Xiantao Zhang (3):
      KVM: ia64: Define new kvm_fpreg struture to replace ia64_fpreg
      KVM: ia64: fix GVMM module including position-dependent objects
      KVM: ia64: Set KVM_IOAPIC_NUM_PINS to 48

 MAINTAINERS                       |   14 ++++++------
 arch/ia64/kvm/Makefile            |    3 +-
 arch/ia64/kvm/memcpy.S            |    1 +
 arch/ia64/kvm/memset.S            |    1 +
 arch/x86/kvm/i8254.c              |    2 +-
 arch/x86/kvm/lapic.c              |    2 +-
 arch/x86/kvm/x86_emulate.c        |    7 ++++-
 drivers/s390/kvm/kvm_virtio.c     |   40 
+++++++++++++++++++++---------------
 include/asm-ia64/kvm.h            |   12 ++++++++--
 include/asm-x86/kvm_x86_emulate.h |    1 +
 virt/kvm/kvm_main.c               |   29 +++++++++++++-------------
 11 files changed, 65 insertions(+), 47 deletions(-)
 create mode 100644 arch/ia64/kvm/memcpy.S
 create mode 100644 arch/ia64/kvm/memset.S

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

