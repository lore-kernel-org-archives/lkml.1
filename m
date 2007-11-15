Return-Path: <linux-kernel-owner+w=401wt.eu-S1765878AbXKOSYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765878AbXKOSYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765704AbXKOSXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:23:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765686AbXKOSW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:22:59 -0500
Date: Thu, 15 Nov 2007 13:22:31 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711151822.lAFIMVqd028593@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv2 3/4] x86&x86-64 UML support for sys_indirect
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This part adds support for sys_indirect on UML on x86 and x86-64.

 indirect.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/include/asm-um/indirect.h	2007-11-15 09:56:23.000000000 -0800
@@ -0,0 +1,6 @@
+#ifndef __UM_INDIRECT_H
+#define __UM_INDIRECT_H
+
+#include "asm/arch/indirect.h"
+
+#endif
