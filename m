Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZJRR13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZJRR13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 13:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZJRR13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 13:27:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47334 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbZJRR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 13:27:28 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v4 6/7] m68knommu: Move __init_end out of the .init section.
Date: Sun, 18 Oct 2009 13:23:54 -0400
Message-Id: <1255886635-17371-6-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
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
index 0d430da..65e2874 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -168,6 +168,8 @@ SECTIONS {
 		CON_INITCALL
 		SECURITY_INITCALL
 		INIT_RAM_FS
+	} > INIT
+	.init : {
 		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
-- 
1.6.4.3

