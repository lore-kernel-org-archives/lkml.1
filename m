Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXKBPmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXKBPmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbXKBPlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:41:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60096 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbXKBPlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:41:14 -0400
Date: Fri, 2 Nov 2007 11:40:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: caker@linode.com, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/6] UML - Document new ubd flag
Message-ID: <20071102154013.GA10273@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ubd help message didn't document the 'c' flag.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c	2007-11-02 10:59:18.000000000 -0400
+++ linux-2.6/arch/um/drivers/ubd_kern.c	2007-11-02 10:59:59.000000000 -0400
@@ -437,7 +437,10 @@ __uml_help(ubd_setup,
 "    machine by running 'dd' on the device. <n> must be in the range\n"
 "    0 to 7. Appending an 'r' to the number will cause that device\n"
 "    to be mounted read-only. For example ubd1r=./ext_fs. Appending\n"
-"    an 's' will cause data to be written to disk on the host immediately.\n\n"
+"    an 's' will cause data to be written to disk on the host immediately.\n"
+"    'c' will cause the device to be treated as being shared between multiple\n"
+"    UMLs and file locking will be turned off - this is appropriate for a\n"
+"    cluster filesystem and inappropriate at almost all other times.\n\n"
 );
 
 static int udb_setup(char *str)
