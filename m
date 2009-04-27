Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbZD0Uex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbZD0Uex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760219AbZD0UeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:34:01 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55279 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760635AbZD0UeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:34:00 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, David Howells <dhowells@redhat.com>
Subject: [PATCH 03/14] mn10300: Use macros for .bss.page_aligned section.
Date: Mon, 27 Apr 2009 16:32:57 -0400
Message-Id: <1240864388-26315-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240864388-26315-3-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
 <1240864388-26315-2-git-send-email-tabbott@mit.edu>
 <1240864388-26315-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
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

