Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZKPMUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZKPMUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZKPMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 31/42] KVM: Fix printk name error in svm.c
Date: Mon, 16 Nov 2009 14:19:32 +0200
Message-Id: <1258373983-8693-32-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zamsden@redhat.com>

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9a4daca..d1036ce 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -330,13 +330,14 @@ static int svm_hardware_enable(void *garbage)
 		return -EBUSY;
 
 	if (!has_svm()) {
-		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
+		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n",
+		       me);
 		return -EINVAL;
 	}
 	svm_data = per_cpu(svm_data, me);
 
 	if (!svm_data) {
-		printk(KERN_ERR "svm_cpu_init: svm_data is NULL on %d\n",
+		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
 		       me);
 		return -EINVAL;
 	}
-- 
1.6.5.2

