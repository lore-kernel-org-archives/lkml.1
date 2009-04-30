Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbZD3X7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbZD3X7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764646AbZD3Xy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60683 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764647AbZD3Xyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:55 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/6] mn10300: Use macros for .bss.page_aligned section.
Date: Thu, 30 Apr 2009 19:54:16 -0400
Message-Id: <1241135661-9147-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
References: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/mn10300/kernel/vmlinux.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 24de6b9..6ad0fa8 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -131,7 +131,7 @@ SECTIONS
 
   __bss_start = .;		/* BSS */
   .bss : {
-	*(.bss.page_aligned)
+	PAGE_ALIGNED_BSS
 	*(.bss)
   }
   . = ALIGN(4);
-- 
1.6.2.1

