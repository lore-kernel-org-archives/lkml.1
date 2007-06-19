Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXFSIfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXFSIfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXFSIew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:34:52 -0400
Received: from server78.greatnet.de ([83.133.96.102]:49422 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbXFSIev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:34:51 -0400
Message-ID: <46778EBC.3060902@nachtwindheim.de>
Date: Tue, 19 Jun 2007 10:07:24 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: linux-audit@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kerneldoc fix in audit_core_dumps
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix parameter name in audit_core_dumps for kerneldoc.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e36481e..028650c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2040,7 +2040,7 @@ int __audit_signal_info(int sig, struct
 
 /**
  * audit_core_dumps - record information about processes that end abnormally
- * @sig: signal value
+ * @signr: signal value
  *
  * If a process ends with a core dump, something fishy is going on and we
  * should record the event for investigation.


