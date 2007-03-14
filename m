Return-Path: <linux-kernel-owner+w=401wt.eu-S933861AbXCNFP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861AbXCNFP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933851AbXCNFMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:37 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63740 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933849AbXCNFMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:16 -0400
Message-Id: <20070314051047.685668692@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 01/18] toplevel Kconfig changes
Content-Disposition: inline; filename=x86-kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create a toplevel Kconfig for arch/x86 and update the i386
and x86_64 Kconfigs as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
new file mode 100644
index 0000000..18223ff
--- /dev/null
+++ b/arch/x86/Kconfig
@@ -0,0 +1,4 @@
+
+
+source arch/x86/oprofile/Kconfig
+
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 56eb14c..3a2e117 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -738,7 +738,7 @@ source fs/Kconfig
 menu "Instrumentation Support"
         depends on EXPERIMENTAL
 
-source "arch/x86_64/oprofile/Kconfig"
+source "arch/x86/Kconfig"
 
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"

--
