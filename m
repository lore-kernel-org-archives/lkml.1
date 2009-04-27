Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbZD0Ui2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbZD0Ui2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761218AbZD0Uhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:37:45 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56727 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761273AbZD0Uhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:37:43 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 08/14] sh: Use macros for .data.page_aligned section.
Date: Mon, 27 Apr 2009 16:33:02 -0400
Message-Id: <1240864388-26315-9-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240864388-26315-8-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
 <1240864388-26315-2-git-send-email-tabbott@mit.edu>
 <1240864388-26315-3-git-send-email-tabbott@mit.edu>
 <1240864388-26315-4-git-send-email-tabbott@mit.edu>
 <1240864388-26315-5-git-send-email-tabbott@mit.edu>
 <1240864388-26315-6-git-send-email-tabbott@mit.edu>
 <1240864388-26315-7-git-send-email-tabbott@mit.edu>
 <1240864388-26315-8-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/vmlinux_32.lds.S |    3 +--
 arch/sh/kernel/vmlinux_64.lds.S |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index 99a4124..325af0b 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -69,8 +69,7 @@ SECTIONS
 		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
 
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA
 
 		__nosave_begin = .;
 		*(.data.nosave)
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index cb46577..b222700 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -78,8 +78,7 @@ SECTIONS
 		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
 
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		PAGE_ALIGNED_DATA
 
 		__nosave_begin = .;
 		*(.data.nosave)
-- 
1.6.2.1

