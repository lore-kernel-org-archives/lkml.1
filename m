Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXBGTy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXBGTy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422915AbXBGTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:54:58 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34295 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1422760AbXBGTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:54:57 -0500
Message-Id: <200702071947.l17JlhGW006605@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 2/7] UML - SIGIO locking comment
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 07 Feb 2007 14:47:43 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Comment the use of a mysterious-looking lock.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/kernel/sigio.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.18-mm/arch/um/kernel/sigio.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/sigio.c	2007-01-10 15:12:51.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/sigio.c	2007-01-10 15:44:08.000000000 -0500
@@ -42,6 +42,7 @@ int write_sigio_irq(int fd)
 	return(0);
 }
 
+/* These are called from os-Linux/sigio.c to protect its pollfds arrays. */
 static DEFINE_SPINLOCK(sigio_spinlock);
 
 void sigio_lock(void)

