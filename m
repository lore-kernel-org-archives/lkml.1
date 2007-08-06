Return-Path: <linux-kernel-owner+w=401wt.eu-S1761861AbXHFAsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761861AbXHFAsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 20:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHFAsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 20:48:42 -0400
Received: from ozlabs.org ([203.10.76.45]:47146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXHFAsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 20:48:42 -0400
Subject: [PATCH] Enable lguest drivers in Kconfig
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lguest <lguest@ozlabs.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 10:48:18 +1000
Message-Id: <1186361298.32112.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lguest drivers need to default to "Y" otherwise they're never selected
for new builds.  (We don't bother prompting, because they're less than
4k combined, and implied by selecting lguest support).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

===================================================================
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -21,8 +21,10 @@ config LGUEST_GUEST
 
 config LGUEST_NET
 	tristate
+	default y
 	depends on LGUEST_GUEST && NET
 
 config LGUEST_BLOCK
 	tristate
+	default y
 	depends on LGUEST_GUEST && BLOCK


