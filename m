Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXA3OlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXA3OlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXA3OlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:41:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:53281 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965519AbXA3OlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:41:01 -0500
Subject: [PATCH 5/11] KVM: fix what looks like an obvious typo in the file
	drivers/kvm/svm.c
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:41:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144100.23B48A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -1163,7 +1163,7 @@ static int svm_set_msr(struct kvm_vcpu *
 	case MSR_K6_STAR:
 		vcpu->svm->vmcb->save.star = data;
 		break;
-#ifdef CONFIG_X86_64_
+#ifdef CONFIG_X86_64
 	case MSR_LSTAR:
 		vcpu->svm->vmcb->save.lstar = data;
 		break;
