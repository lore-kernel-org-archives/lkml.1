Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZHSNEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZHSNEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZHSNEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50582 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752011AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/47] KVM: x86 emulator: Add missing EFLAGS bit definitions
Date: Wed, 19 Aug 2009 16:02:22 +0300
Message-Id: <1250686963-8357-27-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Signed-off-by: Christoph Egger <christoph.egger@amd.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ef4dfca..67af33a 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -320,8 +320,11 @@ static u32 group2_table[] = {
 };
 
 /* EFLAGS bit definitions. */
+#define EFLG_VM (1<<17)
+#define EFLG_RF (1<<16)
 #define EFLG_OF (1<<11)
 #define EFLG_DF (1<<10)
+#define EFLG_IF (1<<9)
 #define EFLG_SF (1<<7)
 #define EFLG_ZF (1<<6)
 #define EFLG_AF (1<<4)
-- 
1.6.3.3

