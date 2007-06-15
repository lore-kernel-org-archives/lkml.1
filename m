Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbXFOPgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbXFOPgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXFOPfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:35:42 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37572 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXFOPfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:35:40 -0400
Date: Fri, 15 Jun 2007 11:34:50 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Arun Raghavan <arunsr@cse.iitk.ac.in>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - add asm/paravirt.h
Message-ID: <20070615153450.GA7725@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add asm-um/paravirt.h so that i386 headers that get pulled into UML
don't cause build failures when they want asm/paravirt.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/paravirt.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.21-mm/include/asm-um/paravirt.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-mm/include/asm-um/paravirt.h	2007-06-14 12:02:04.000000000 -0400
@@ -0,0 +1,6 @@
+#ifndef __UM_PARAVIRT_H
+#define __UM_PARAVIRT_H
+
+#include "asm/arch/paravirt.h"
+
+#endif
