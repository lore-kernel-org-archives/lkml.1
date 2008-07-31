Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYGaItZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYGaItZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYGaItQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:49:16 -0400
Received: from il.qumranet.com ([212.179.150.194]:14964 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYGaItP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:49:15 -0400
Message-ID: <48917C8A.1070902@qumranet.com>
Date: Thu, 31 Jul 2008 11:49:14 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] [RESEND] KVM MMU notifiers support for 2.6.27-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from repo & branch at:

   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git 
kvm-updates-2.6.27

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
  virt/kvm/kvm_main.c        |  155 
++++++++++++++++++++++++++++++++++++++++++-
  7 files changed, 311 insertions(+), 11 deletions(-)
