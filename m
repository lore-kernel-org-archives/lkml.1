Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbXDZJ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbXDZJ1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXDZJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:26 -0400
Received: from il.qumranet.com ([82.166.9.18]:52998 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbXDZJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] KVM updates for 2.6.22
Date: Thu, 26 Apr 2007 12:22:00 +0300
Message-Id: <11775793382353-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a continuation of my April 1 patchset.  Both will be submitted
shortly for inclusion in Linux 2.6.22.  Happily, significant performance
improvements are included, rather than just stability and correctness
fixes.

 drivers/kvm/kvm.h         |   40 +++++++++------
 drivers/kvm/kvm_main.c    |  120 ++++++++++++++++++++++++--------------------
 drivers/kvm/kvm_vmx.h     |   14 -----
 drivers/kvm/mmu.c         |   83 ++++++++++++++++++++++++++-----
 drivers/kvm/paging_tmpl.h |    2 +-
 drivers/kvm/svm.c         |   62 ++++++++++++++++--------
 drivers/kvm/vmx.c         |  113 +++++++++++++++++++++++++++++++-----------
 drivers/kvm/x86_emulate.c |   46 +++--------------
 drivers/kvm/x86_emulate.h |   32 ++----------
 9 files changed, 301 insertions(+), 211 deletions(-)
