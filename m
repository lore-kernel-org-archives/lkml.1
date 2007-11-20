Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXKTGyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXKTGyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbXKTGxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:53:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759059AbXKTGxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:53:41 -0500
Date: Tue, 20 Nov 2007 01:53:14 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711200653.lAK6rEDk025885@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv4 3/6] UML support for sys_indirect
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
