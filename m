Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbZEMW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbZEMW1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZEMW1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:27:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:50636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZEMW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:27:44 -0400
Subject: [PATCH -tip] x86: amd_iommu_init.c use NULL pointer
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 May 2009 03:57:08 +0530
Message-Id: <1242253628.3364.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8c0be09..f728b12 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -898,7 +898,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 /* called for unity map ACPI definition */
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
-	struct unity_map_entry *e = 0;
+	struct unity_map_entry *e = NULL;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (e == NULL)
-- 
1.6.0.6



