Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZF1LK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZF1LK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZF1LKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:10:19 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46396 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbZF1LKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:10:18 -0400
Date: Sun, 28 Jun 2009 13:10:19 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: depend on HAVE_ARCH_KMEMCHECK
Message-ID: <20090628111019.GA15900@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make it selectable if it is available

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 lib/Kconfig.kmemcheck |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.kmemcheck b/lib/Kconfig.kmemcheck
index 603c81b..9ccca0d 100644
--- a/lib/Kconfig.kmemcheck
+++ b/lib/Kconfig.kmemcheck
@@ -1,6 +1,7 @@
 config HAVE_ARCH_KMEMCHECK
 	bool
 
+if HAVE_ARCH_KMEMCHECK
 menuconfig KMEMCHECK
 	bool "kmemcheck: trap use of uninitialized memory"
 	depends on DEBUG_KERNEL
@@ -89,3 +90,4 @@ config KMEMCHECK_BITOPS_OK
 	  accesses where not all the bits are initialized at the same time.
 	  This may also hide some real bugs.
 
+endif
-- 
1.6.0.6

