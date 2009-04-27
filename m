Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZD0SGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZD0SGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbZD0SGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:06:23 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62671 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758775AbZD0SGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:06:22 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, David Howells <dhowells@redhat.com>
Subject: [PATCH 1/8] frv: Remove unused header asm/init.h.
Date: Mon, 27 Apr 2009 14:02:20 -0400
Message-Id: <1240855347-19316-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems nothing has included the frv asm/init.h header for some time,
and its actual contents are out of date with include/linux/init.h.  So
just delete it.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/init.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)
 delete mode 100644 arch/frv/include/asm/init.h

diff --git a/arch/frv/include/asm/init.h b/arch/frv/include/asm/init.h
deleted file mode 100644
index 8b15838..0000000
--- a/arch/frv/include/asm/init.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_INIT_H
-#define _ASM_INIT_H
-
-#define __init __attribute__ ((__section__ (".text.init")))
-#define __initdata __attribute__ ((__section__ (".data.init")))
-/* For assembly routines */
-#define __INIT		.section	".text.init",#alloc,#execinstr
-#define __FINIT		.previous
-#define __INITDATA	.section	".data.init",#alloc,#write
-
-#endif
-
-- 
1.6.2.1

