Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbXL3HK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbXL3HK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXL3HKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:43 -0500
Received: from il.qumranet.com ([82.166.9.18]:59466 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXL3HKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 00/52] KVM patch queue review for 2.6.25 merge window (part III)
Date: Sun, 30 Dec 2007 09:09:46 +0200
Message-Id: <1198998638-22713-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The third installment of the 2.6.25 kvm patch queue, for your reviewing
pleasure.  This time, a diffstat of the files affected by these 53 patches is
appended.

 drivers/kvm/kvm.h         |  384 ++++++---------------------------------------
 drivers/kvm/kvm_main.c    |  192 +++++++---------------
 drivers/kvm/mmu.c         |  113 +++++++++++---
 drivers/kvm/paging_tmpl.h |  156 +++++++------------
 drivers/kvm/svm.c         |    4 +-
 drivers/kvm/vmx.c         |    5 +-
 drivers/kvm/x86.c         |  261 +++++++++++++++++++++++++------
 drivers/kvm/x86.h         |  331 ++++++++++++++++++++++++++++++++++++++
 drivers/kvm/x86_emulate.c |   38 +++++-
 drivers/kvm/x86_emulate.h |   18 +--
 include/asm-x86/Kbuild    |    1 +
 include/asm-x86/kvm.h     |  155 ++++++++++++++++++
 include/linux/kvm.h       |  137 +----------------
 13 files changed, 1003 insertions(+), 792 deletions(-)
