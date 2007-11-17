Return-Path: <linux-kernel-owner+w=401wt.eu-S1764801AbXKQFcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764801AbXKQFcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 00:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXKQFcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 00:32:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXKQFcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 00:32:00 -0500
Date: Sat, 17 Nov 2007 00:31:36 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711170531.lAH5VaWR025234@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv3 3/4] UML support for sys_indirect
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This part adds support for sys_indirect for UML.

 indirect.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- /dev/null
+++ include/asm-um/indirect.h
@@ -0,0 +1,6 @@
+#ifndef __UM_INDIRECT_H
+#define __UM_INDIRECT_H
+
+#include "asm/arch/indirect.h"
+
+#endif
