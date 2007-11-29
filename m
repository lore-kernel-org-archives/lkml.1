Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbXK2QtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbXK2QtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760410AbXK2Qsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:48:36 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:48153 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbXK2Qse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:48:34 -0500
Date: Thu, 29 Nov 2007 11:48:20 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] UML - Add asm-um/asm.h
Message-ID: <20071129164820.GA7294@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This should accompany git-x86.patch to mainline ]

git-x86.patch introduces asm-x86/asm.h.  UML needs to follow this with
an asm/asm.h of its own.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 include/asm-um/asm.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.22/include/asm-um/asm.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22/include/asm-um/asm.h	2007-11-21 12:15:03.000000000 -0500
@@ -0,0 +1,6 @@
+#ifndef __UM_ASM_H
+#define __UM_ASM_H
+
+#include "asm/arch/asm.h"
+
+#endif
