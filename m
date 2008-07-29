Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYG2Jme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYG2Jme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbYG2JmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:42:16 -0400
Received: from il.qumranet.com ([212.179.150.194]:17415 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbYG2JmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:42:14 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM MMU notifiers support for 2.6.27-rc1
Date: Tue, 29 Jul 2008 12:42:13 +0300
Message-Id: <1217324533-17229-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from repo & branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.27

to receive the mmu notifiers support for kvm.  This allows the full range
of Linux virtual memory management, such as swapping and page migration,
to apply to kvm virtual machines.

Andrea Arcangeli (3):
      KVM: Allow reading aliases with mmu_lock
      KVM: Allow browsing memslots with mmu_lock
      KVM: Synchronize guest physical memory map to host virtual memory map

Avi Kivity (1):
      KVM: Advertise synchronized mmu support to userspace

 arch/x86/kvm/mmu.c         |  100 ++++++++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |   12 ++++
 arch/x86/kvm/x86.c         |   24 +++++--
 include/asm-x86/kvm_host.h |    6 ++
 include/linux/kvm.h        |    1 +
 include/linux/kvm_host.h   |   24 +++++++
 virt/kvm/kvm_main.c        |  155 ++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 311 insertions(+), 11 deletions(-)
