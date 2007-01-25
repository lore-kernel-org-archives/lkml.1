Return-Path: <linux-kernel-owner+w=401wt.eu-S1030373AbXAYXGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030373AbXAYXGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030465AbXAYXGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:06:11 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:33741 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030373AbXAYXGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:06:10 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 25 Jan 2007 18:05:46 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Fix "CONFIG_X86_64_" typo in drivers/kvm/svm.c.
Message-ID: <Pine.LNX.4.64.0701251803570.14801@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_VC 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Fix what looks like an obvious typo in the file drivers/kvm/svm.c.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  is this, in fact, a typo?

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 7397bfb..1764fb6 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1149,7 +1149,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	case MSR_K6_STAR:
 		vcpu->svm->vmcb->save.star = data;
 		break;
-#ifdef CONFIG_X86_64_
+#ifdef CONFIG_X86_64
 	case MSR_LSTAR:
 		vcpu->svm->vmcb->save.lstar = data;
 		break;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
