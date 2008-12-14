Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYLNIOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYLNIOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYLNIHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59930 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 12/36] KVM: fix sparse warning
Date: Sun, 14 Dec 2008 10:06:45 +0200
Message-Id: <1229242029-13410-13-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Impact: make global function static

  virt/kvm/kvm_main.c:85:6: warning: symbol 'kvm_rebooting' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
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
1.6.0.3

