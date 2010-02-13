Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0BMIFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:05:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/39] KVM: PPC: Export __giveup_vsx
Date: Sat, 13 Feb 2010 10:01:49 +0200
Message-Id: <1266048119-14325-30-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

We need to explicitly only giveup VSX in KVM, so let's export that
specific function to module space.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kernel/ppc_ksyms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index 4254514..ab3e392 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -107,6 +107,7 @@ EXPORT_SYMBOL(giveup_altivec);
 #endif /* CONFIG_ALTIVEC */
 #ifdef CONFIG_VSX
 EXPORT_SYMBOL(giveup_vsx);
+EXPORT_SYMBOL_GPL(__giveup_vsx);
 #endif /* CONFIG_VSX */
 #ifdef CONFIG_SPE
 EXPORT_SYMBOL(giveup_spe);
-- 
1.6.5.3

