Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZD0Xkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZD0Xkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZD0XkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:40:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbZD0XkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:40:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Remove unused header asm/init.h.
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@mit.edu>,
       David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 28 Apr 2009 00:37:53 +0100
Message-ID: <20090427233753.3246.96982.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@MIT.EDU>

It seems nothing has included the frv asm/init.h header for some time, and its
actual contents are out of date with include/linux/init.h.  So just delete it.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
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

