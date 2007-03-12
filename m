Return-Path: <linux-kernel-owner+w=401wt.eu-S965210AbXCLGul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965210AbXCLGul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 02:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965233AbXCLGul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 02:50:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:57829 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965210AbXCLGuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 02:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jSdhNAYxHa/R3ON1Kueq+V10BFGj9somQPLR0NPtjW3jz1+e559Ce1uQ6VWtwmaECiYvNXMDIE+GP0d/5HuYb3ex0xFNoKLM/fM/9nflvcMV6bR0snh4kWSRSWwE3i8gqTs3nYBehbB/f/pOkd+s56aKzOeJhgAJc8jLk6wBqvA=
Message-ID: <2375c9f90703112350m5d28bacj4745913261a6bec5@mail.gmail.com>
Date: Mon, 12 Mar 2007 14:50:38 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org, avi@qumranet.com
Subject: [PATCH]Replace 0 with NULL when returning a pointer
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use NULL to indicate we are returning a pointer rather than an integer
and to eliminate some sparse warnings.

Signed-off-by: Cong WANG <xiyou.wangcong@gmail.com>
---
--- drivers/kvm/vmx.c.orig	2007-03-11 21:41:03.000000000 +0800
+++ drivers/kvm/vmx.c	2007-03-12 14:25:11.000000000 +0800
@@ -98,7 +98,7 @@ static struct vmx_msr_entry *find_msr_en
 	for (i = 0; i < vcpu->nmsrs; ++i)
 		if (vcpu->guest_msrs[i].index == msr)
 			return &vcpu->guest_msrs[i];
-	return 0;
+	return NULL;
 }

 static void vmcs_clear(struct vmcs *vmcs)
