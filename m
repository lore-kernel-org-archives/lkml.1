Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYCaOiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYCaOiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYCaOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:30 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51274
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYCaOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/40] KVM updates for the 2.6.26 merge window (part I)
Date: Mon, 31 Mar 2008 17:36:44 +0300
Message-Id: <1206974244-9716-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the first forty of about a hundred patches I have queued for 2.6.26.
Note that a few will go through git-s390, maybe a couple through x86.git, and
a few to 2.6.25-rc.

The ia64 patches are not included as they are being reviewed, but I hope to have
them merged in time for the 2.6.26 merge window.

Happy reviewing!

Diffstat for this batch:

 arch/x86/Kconfig           |   11 ++
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/kvmclock.c |  160 ++++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c |    5 +
 arch/x86/kernel/setup_64.c |    5 +
 arch/x86/kvm/kvm_svm.h     |    2 +
 arch/x86/kvm/mmu.c         |  168 +++++++++++++++++++++++-------
 arch/x86/kvm/mmu.h         |    6 +
 arch/x86/kvm/paging_tmpl.h |   24 ++---
 arch/x86/kvm/svm.c         |  211 ++++++++++++++++++++++++++++--------
 arch/x86/kvm/vmx.c         |  100 +++++++++++++++---
 arch/x86/kvm/vmx.h         |   10 ++-
 arch/x86/kvm/x86.c         |  147 +++++++++++++++++++++++--
 arch/x86/kvm/x86_emulate.c |  252 ++++++++++++++++++++++++-------------------
 include/asm-x86/kvm_host.h |   16 +++-
 include/asm-x86/kvm_para.h |   25 +++++
 include/linux/kvm.h        |    3 +
 include/linux/kvm_host.h   |    6 +-
 virt/kvm/kvm_main.c        |   13 ++-
 19 files changed, 919 insertions(+), 246 deletions(-)
