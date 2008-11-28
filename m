Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYK1TtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYK1TtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYK1TtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:49:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:2802 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYK1TtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:49:08 -0500
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 17:02:42 +0100
Subject: [PATCH] KVM: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <49304b32.0baa660a.462a.ffffb75d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make global function static

  virt/kvm/kvm_main.c:85:6: warning: symbol 'kvm_rebooting' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 54d25e6..8dab7ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -82,7 +82,7 @@ struct dentry *kvm_debugfs_dir;
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 
-bool kvm_rebooting;
+static bool kvm_rebooting;
 
 #ifdef KVM_CAP_DEVICE_ASSIGNMENT
 
-- 
1.5.6.3

