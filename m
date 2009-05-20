Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbZETL3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbZETL3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZETLUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55268 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbZETLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:48 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 07/46] KVM: remove pointless conditional before kfree() in lapic initialization
Date: Wed, 20 May 2009 14:18:04 +0300
Message-Id: <1242818323-10413-8-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

Remove pointless conditional before kfree().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 637bb80..34516bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1588,8 +1588,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 	}
 out:
-	if (lapic)
-		kfree(lapic);
+	kfree(lapic);
 	return r;
 }
 
-- 
1.6.0.6

