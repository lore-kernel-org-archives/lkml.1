Return-Path: <linux-kernel-owner+w=401wt.eu-S965432AbXAWTfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965432AbXAWTfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965442AbXAWTe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:34:59 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:33094 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965429AbXAWTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:34:55 -0500
Message-Id: <200701231927.l0NJRhZ8005353@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 4/7] UML - locking comments in startup code
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 23 Jan 2007 14:27:43 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a couple of comments about some non-locked data.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/start_up.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.18-mm/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/start_up.c	2007-01-13 17:50:31.000000000 +1100
+++ linux-2.6.18-mm/arch/um/os-Linux/start_up.c	2007-01-17 12:29:59.000000000 +1100
@@ -133,6 +133,7 @@ static int stop_ptraced_child(int pid, v
 	return ret;
 }
 
+/* Changed only during early boot */
 int ptrace_faultinfo = 1;
 int ptrace_ldt = 1;
 int proc_mm = 1;
@@ -160,6 +161,7 @@ __uml_setup("mode=skas0", mode_skas0_cmd
 		"    specify mode=tt. Note that this was recently added - on \n"
 		"    older kernels you must use simply \"skas0\".\n\n");
 
+/* Changed only during early boot */
 static int force_sysemu_disabled = 0;
 
 static int __init nosysemu_cmd_param(char *str, int* add)

