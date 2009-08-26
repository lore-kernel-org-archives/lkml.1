Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbZHZKdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbZHZKdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbZHZKda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/47] KVM: SVM: enable nested svm by default
Date: Wed, 26 Aug 2009 13:29:54 +0300
Message-Id: <1251282609-12835-33-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Nested SVM is (in my experience) stable enough to be enabled by
default. So omit the requirement to pass a module parameter.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 825035e..be0f6ef 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -124,7 +124,7 @@ static int npt = 1;
 
 module_param(npt, int, S_IRUGO);
 
-static int nested = 0;
+static int nested = 1;
 module_param(nested, int, S_IRUGO);
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
-- 
1.6.4.1

