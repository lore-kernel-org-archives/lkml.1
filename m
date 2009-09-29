Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZI2VlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZI2VlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZI2VlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbZI2VlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:41:00 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4: kvm 3/4] Fix printk name error in svm.c
Date: Tue, 29 Sep 2009 11:38:36 -1000
Message-Id: <1254260317-3490-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1254260317-3490-2-git-send-email-zamsden@redhat.com>
References: <4AC1C59F.6010703@redhat.com>
 <1254260317-3490-1-git-send-email-zamsden@redhat.com>
 <1254260317-3490-2-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
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
1.6.4.4

