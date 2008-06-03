Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYFCTFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYFCTFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758314AbYFCTEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:04:16 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58524 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbYFCTEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:04:14 -0400
Date: Tue, 3 Jun 2008 15:02:38 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/6] UML - PATH_MAX needs limits.h
Message-ID: <20080603190237.GA9521@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Include limits.h to get a definition of PATH_MAX.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/helper.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-git/arch/um/os-Linux/helper.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/helper.c	2008-05-14 10:44:02.000000000 -0400
+++ linux-2.6-git/arch/um/os-Linux/helper.c	2008-06-02 15:50:10.000000000 -0400
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <sched.h>
+#include <linux/limits.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include "kern_constants.h"
