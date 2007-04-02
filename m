Return-Path: <linux-kernel-owner+w=401wt.eu-S965940AbXDBV1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965940AbXDBV1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965944AbXDBV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:27:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965940AbXDBV1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:27:36 -0400
Date: Mon, 2 Apr 2007 18:28:20 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] Arch-specific includes
Message-ID: <20070402212820.GD7711@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry if this gets resent. My fault ;-)

All that is left for the architectures, is the room for some specific
definitions.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"

--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lgarchdefs.patch"

--- /dev/null	2007-04-02 15:35:49.510433377 -0300
+++ i386/lguest_defs.h	2007-04-02 16:19:27.000000000 -0300
@@ -0,0 +1,7 @@
+#ifndef _LGUEST_DEFS_H_
+#define _LGUEST_DEFS_H_
+
+/* LGUEST_TOP_ADDRESS comes from the Makefile */
+#define RESERVE_TOP_ADDRESS LGUEST_GUEST_TOP - 1024*1024
+
+#endif
--- /dev/null	2007-04-02 15:35:49.510433377 -0300
+++ x86_64/lguest_defs.h	2007-04-02 16:19:27.000000000 -0300
@@ -0,0 +1,11 @@
+#ifndef _LGUEST_DEFS_H_
+#define _LGUEST_DEFS_H_
+
+#include <asm/vsyscall.h>
+
+/* LGUEST_TOP_ADDRESS comes from the Makefile */
+#define RESERVE_TOP_ADDRESS LGUEST_GUEST_TOP
+
+#define BOOT_PGTABLE "boot_level4_pgt"
+
+#endif

--DiL7RhKs8rK9YGuF--
