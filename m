Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXKGSii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXKGSii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbXKGShR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:37:17 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:60201 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000AbXKGShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:37:15 -0500
Date: Wed, 7 Nov 2007 13:36:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH 1/5] UML - Delete some unused headers
Message-ID: <20071107183637.GA8462@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Day noticed a few unused headers in UML, so this gets rid of them.

Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/misc_constants.h |    6 ------
 arch/um/include/signal_kern.h    |   22 ----------------------
 arch/um/include/skas/mode-skas.h |   11 -----------
 3 files changed, 39 deletions(-)

Index: linux-2.6/arch/um/include/misc_constants.h
===================================================================
--- linux-2.6.orig/arch/um/include/misc_constants.h	2007-03-27 17:07:26.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __MISC_CONSTANT_H_
-#define __MISC_CONSTANT_H_
-
-#include <user_constants.h>
-
-#endif
Index: linux-2.6/arch/um/include/signal_kern.h
===================================================================
--- linux-2.6.orig/arch/um/include/signal_kern.h	2007-03-27 17:07:26.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,22 +0,0 @@
-/* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __SIGNAL_KERN_H__
-#define __SIGNAL_KERN_H__
-
-extern int have_signals(void *t);
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6/arch/um/include/skas/mode-skas.h
===================================================================
--- linux-2.6.orig/arch/um/include/skas/mode-skas.h	2007-11-05 14:01:47.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,11 +0,0 @@
-/*
- * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
- * Licensed under the GPL
- */
-
-#ifndef __MODE_SKAS_H__
-#define __MODE_SKAS_H__
-
-extern void kill_off_processes_skas(void);
-
-#endif
