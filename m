Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbZDIRmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbZDIRmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbZDIRmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:42:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49657 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270AbZDIRmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:42:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Kill MN10300's own profiling Kconfig
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Thu, 09 Apr 2009 18:41:23 +0100
Message-ID: <20090409174123.6017.69095.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill MN10300's own profiling Kconfig as this is superfluous given that the
profiling options have moved to init/Kconfig and arch/Kconfig.  Not only is
this now superfluous, but the dependencies are not correct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig          |    2 --
 arch/mn10300/oprofile/Kconfig |   23 -----------------------
 2 files changed, 0 insertions(+), 25 deletions(-)
 delete mode 100644 arch/mn10300/oprofile/Kconfig


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 41d1682..3559267 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -370,5 +370,3 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
-
-source "arch/mn10300/oprofile/Kconfig"
diff --git a/arch/mn10300/oprofile/Kconfig b/arch/mn10300/oprofile/Kconfig
deleted file mode 100644
index 19d3773..0000000
--- a/arch/mn10300/oprofile/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-
-menu "Profiling support"
-	depends on EXPERIMENTAL
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-endmenu
-

