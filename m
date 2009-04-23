Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZDWMhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZDWMhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbZDWMhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:37:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33330 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbZDWMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:37:21 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.30-rc3
Date: Thu, 23 Apr 2009 15:36:10 +0300
Message-Id: <1240490170-19928-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following kvm fixes from repo and branch at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.30

The only noteworthy fix is that a bug in kvm global page handling during
guest invlpg breaks the FreeBSD kernel, so we're dropping that optimization
until further notice.

Avi Kivity (1):
      KVM: MMU: Fix off-by-one calculating large page count

Jan Kiszka (2):
      KVM: Fix overlapping check for memory slots
      KVM: Unregister cpufreq notifier on unload

Jes Sorensen (1):
      KVM: ia64: fix locking order entering guest

Joerg Roedel (1):
      KVM: x86: release time_page on vcpu destruction

Marcelo Tosatti (1):
      KVM: MMU: disable global page optimization

 arch/ia64/kvm/kvm-ia64.c |   14 ++++++++------
 arch/x86/kvm/mmu.c       |    2 +-
 arch/x86/kvm/x86.c       |    8 ++++++++
 include/linux/kvm.h      |    2 ++
 virt/kvm/kvm_main.c      |   11 +++++------
 5 files changed, 24 insertions(+), 13 deletions(-)
