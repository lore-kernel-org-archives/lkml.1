Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbZJMBdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbZJMBdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbZJMBdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:33:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41760 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755700AbZJMBdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:33:43 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 6/7] m68knommu: Move __init_end out of the .init section.
Date: Mon, 12 Oct 2009 21:30:12 -0400
Message-Id: <1255397413-4862-7-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255397413-4862-6-git-send-email-tabbott@ksplice.com>
References: <4AD3BFD8.90408@snapgear.com>
 <1255397413-4862-1-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-2-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-3-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-4-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-5-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-6-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 73fe172..49d5c4d 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -169,6 +169,8 @@ SECTIONS {
 		CON_INITCALL
 		SECURITY_INITCALL
 		INIT_RAM_FS
+	} > INIT
+	.init_end : {
 		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
-- 
1.6.4.3

