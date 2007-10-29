Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXJ2SUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXJ2SUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbXJ2STz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:19:55 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25397 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbXJ2STy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:19:54 -0400
Date: Mon, 29 Oct 2007 11:19:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH/RFC] register_cpu __devinit or __cpuinit
Message-Id: <20071029111929.cdc8e929.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Is there some reason why register_cpu() is __devinit instead of __cpuinit ?
Make it __cpuinit.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc1-git4.orig/drivers/base/cpu.c
+++ linux-2.6.24-rc1-git4/drivers/base/cpu.c
@@ -110,7 +110,7 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
  *
  * Initialize and register the CPU device.
  */
-int __devinit register_cpu(struct cpu *cpu, int num)
+int __cpuinit register_cpu(struct cpu *cpu, int num)
 {
 	int error;
 	cpu->node_id = cpu_to_node(num);
