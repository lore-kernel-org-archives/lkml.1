Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbZB1Bnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbZB1Bnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZB1BmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41767 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/30] x86: Add EFER descriptions for FFXSR
Date: Sat, 28 Feb 2009 03:41:28 +0200
Message-Id: <1235785309-12835-10-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

AMD k10 includes support for the FFXSR feature, which leaves out
XMM registers on FXSAVE/FXSAVE when the EFER_FFXSR bit is set in
EFER.

The CPUID feature bit exists already, but the EFER bit is missing
currently, so this patch adds it to the list of known EFER bits.

Signed-off-by: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/msr-index.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 46e9646..f4e505f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -19,12 +19,14 @@
 #define _EFER_LMA		10 /* Long mode active (read-only) */
 #define _EFER_NX		11 /* No execute enable */
 #define _EFER_SVME		12 /* Enable virtualization */
+#define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
 
 #define EFER_SCE		(1<<_EFER_SCE)
 #define EFER_LME		(1<<_EFER_LME)
 #define EFER_LMA		(1<<_EFER_LMA)
 #define EFER_NX			(1<<_EFER_NX)
 #define EFER_SVME		(1<<_EFER_SVME)
+#define EFER_FFXSR		(1<<_EFER_FFXSR)
 
 /* Intel MSRs. Some also available on other CPUs */
 #define MSR_IA32_PERFCTR0		0x000000c1
-- 
1.6.0.6

