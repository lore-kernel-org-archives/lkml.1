Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbZD0Uej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbZD0Uej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760344AbZD0Udf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:33:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55102 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760356AbZD0Udd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:33:33 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 12/14] mn10300: Drop unused .data.idt section.
Date: Mon, 27 Apr 2009 16:33:06 -0400
Message-Id: <1240864388-26315-13-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240864388-26315-12-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
 <1240864388-26315-2-git-send-email-tabbott@mit.edu>
 <1240864388-26315-3-git-send-email-tabbott@mit.edu>
 <1240864388-26315-4-git-send-email-tabbott@mit.edu>
 <1240864388-26315-5-git-send-email-tabbott@mit.edu>
 <1240864388-26315-6-git-send-email-tabbott@mit.edu>
 <1240864388-26315-7-git-send-email-tabbott@mit.edu>
 <1240864388-26315-8-git-send-email-tabbott@mit.edu>
 <1240864388-26315-9-git-send-email-tabbott@mit.edu>
 <1240864388-26315-10-git-send-email-tabbott@mit.edu>
 <1240864388-26315-11-git-send-email-tabbott@mit.edu>
 <1240864388-26315-12-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nothing gets put into .data.idt on this architecture, eliminate
it from the linker script.

This change was apparently proposed previously:
<http://lkml.indiana.edu/hypermail/linux/kernel/0802.2/2538.html>

CCing the author and people who acked that patch in case there was a
reason it wasn't applied.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/mn10300/kernel/vmlinux.lds.S |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 6ad0fa8..364250f 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -59,9 +59,6 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
-  . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : { *(.data.idt) }
-
   . = ALIGN(32);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
-- 
1.6.2.1

