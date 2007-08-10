Return-Path: <linux-kernel-owner+w=401wt.eu-S934677AbXHJOiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbXHJOiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbXHJOhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:37:54 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7378 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752997AbXHJOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:37:54 -0400
X-Greylist: delayed 1260 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 10:37:53 EDT
To: LKML <linux-kernel@vger.kernel.org>
Cc: balbir@in.ibm.com
Cc: jlan@engr.sgi.com
From: Maxim Uvarov <muvarov@ru.mvista.com>
Subject: [PATCH] Missed "," character in printf in print_delayacct().
Date: Fri, 10 Aug 2007 18:16:47 +0000
Message-ID: <20070810181647.30167.94665.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry I've removed "," character from Documentation/accounting/getdelays.c
with taskstats-add-context-switch-counters.patch.

It is needed to turn it back.	


Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
                                                      
---

 Documentation/accounting/getdelays.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 24c5aad..cbee3a2 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t)
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n"
+	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,

