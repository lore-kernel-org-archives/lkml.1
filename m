Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZB0KfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZB0KfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZB0K2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/37] powerpc/fsl-booke: declare tlbcam_index for use in c
Date: Fri, 27 Feb 2009 12:26:55 +0200
Message-Id: <1235730420-7929-33-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

So, KVM needs to read tlbcam_index to know exactly
which TLB1 entry is unused by host.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/mmu-fsl-booke.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-fsl-booke.h b/arch/powerpc/include/asm/mmu-fsl-booke.h
index 3f941c0..4285b64 100644
--- a/arch/powerpc/include/asm/mmu-fsl-booke.h
+++ b/arch/powerpc/include/asm/mmu-fsl-booke.h
@@ -75,6 +75,8 @@
 
 #ifndef __ASSEMBLY__
 
+extern unsigned int tlbcam_index;
+
 typedef struct {
 	unsigned int	id;
 	unsigned int	active;
-- 
1.6.0.6

