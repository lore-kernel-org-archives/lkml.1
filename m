Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXD2Pun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXD2Pun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbXD2Pul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:50:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:34346 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbXD2PuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:50:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] KVM: More 2.6.22 merge candidates
Date: Sun, 29 Apr 2007 18:50:15 +0300
Message-Id: <1177861822889-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches, improving performance and the userspace interface,
will join the other pending kvm patches which I plan to send at the
end of the week.

 drivers/kvm/kvm.h      |    3 +-
 drivers/kvm/kvm_main.c |   35 +++++++++++------------
 drivers/kvm/kvm_svm.h  |   11 +++----
 drivers/kvm/mmu.c      |    2 +-
 drivers/kvm/svm.c      |   30 +++++++++++---------
 drivers/kvm/vmx.c      |   70 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/kvm.h    |    8 ++---
 7 files changed, 104 insertions(+), 55 deletions(-)
