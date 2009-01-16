Return-Path: <linux-kernel-owner+w=401wt.eu-S936627AbZAPSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936627AbZAPSYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZAPSX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:23:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:43730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbZAPSX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:23:57 -0500
Message-ID: <4970D0A7.90005@suse.com>
Date: Fri, 16 Jan 2009 13:23:35 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: Define ARCH_WANT_FRAME_POINTERS
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit da4276b8299a6544dc41ac2485d3ffca5811b3fb changed a dependency
 for FRAME_POINTER from X86 to ARCH_WANT_FRAME_POINTERS, but didn't
 actually define it.

 This patch adds the definition for ARCH_WANT_FRAME_POINTERS. Without it,
 FRAME_POINTER can't be enabled on x86.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 lib/Kconfig.debug |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -570,6 +570,12 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
+config ARCH_WANT_FRAME_POINTERS
+	bool
+       help
+        Select this config option from the architecture Kconfig, if it
+        it is preferred to always enable frame pointers on the architecture.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \

-- 
Jeff Mahoney
SUSE Labs
