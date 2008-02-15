Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbYBON1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbYBON1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932895AbYBON1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:27:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765739AbYBON1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:27:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] MN10300: Define HZ as a config option
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 15 Feb 2008 13:27:15 +0000
Message-ID: <20080215132715.22161.62836.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define HZ as a config option.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig        |    4 ++++
 include/asm-mn10300/param.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index eedc3a5..6a6409a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -63,6 +63,10 @@ config GENERIC_HARDIRQS
 config HOTPLUG_CPU
 	def_bool n
 
+config HZ
+	int
+	default 1000
+
 mainmenu "Matsushita MN10300/AM33 Kernel Configuration"
 
 source "init/Kconfig"
diff --git a/include/asm-mn10300/param.h b/include/asm-mn10300/param.h
index 54b883e..789b1df 100644
--- a/include/asm-mn10300/param.h
+++ b/include/asm-mn10300/param.h
@@ -12,7 +12,7 @@
 #define _ASM_PARAM_H
 
 #ifdef __KERNEL__
-#define HZ		1000		/* Internal kernel timer frequency */
+#define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 #define USER_HZ		100		/* .. some user interfaces are in
 					 * "ticks" */
 #define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */

