Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbYAAPhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbYAAPhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYAAPgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:25 -0500
Received: from il.qumranet.com ([82.166.9.18]:33761 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYAAPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:23 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 00/54] KVM patch queue review for 2.6.25 merge window (part IV)
Date: Tue,  1 Jan 2008 17:35:26 +0200
Message-Id: <1199201780-14001-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fourth set of kvm updates scheduled for the 2.6.25 merge window.  Please
review.  Diffstat below is for this batch only.

 arch/x86/Kconfig          |    4 +
 drivers/kvm/Kconfig       |    4 +-
 drivers/kvm/i8259.c       |    1 +
 drivers/kvm/ioapic.c      |   36 ++--
 drivers/kvm/iodev.h       |   63 +++++
 drivers/kvm/irq.h         |   21 ++-
 drivers/kvm/kvm.h         |   79 +------
 drivers/kvm/kvm_main.c    |  129 ++++-------
 drivers/kvm/lapic.c       |   25 ++-
 drivers/kvm/mmu.c         |  482 +++++++++++++++++++++-----------------
 drivers/kvm/paging_tmpl.h |  202 +++++++---------
 drivers/kvm/svm.c         |   99 +++-----
 drivers/kvm/svm.h         |    1 +
 drivers/kvm/types.h       |   41 ++++
 drivers/kvm/vmx.c         |   86 ++-----
 drivers/kvm/x86.c         |  469 ++++++++++++++++++++++++++++++++++---
 drivers/kvm/x86.h         |   41 +++-
 drivers/kvm/x86_emulate.c |  568 +++++++++++++++++++++++++--------------------
 drivers/kvm/x86_emulate.h |    5 +-
 include/asm-x86/kvm.h     |   21 ++
 include/linux/Kbuild      |    2 +-
 include/linux/kvm.h       |    6 +
 kernel/fork.c             |    1 +
 23 files changed, 1444 insertions(+), 942 deletions(-)
