Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXIZNwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXIZNwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXIZNvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:51:55 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:26091 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752178AbXIZNvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:51:54 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: balbir@in.ibm.com
Cc: jlan@engr.sgi.com
From: Maxim Uvarov <muvarov@ru.mvista.com>
Subject: [PATCH] Since we have counters in __u64 format we have to print them
	with %llu macros.
Date: Wed, 26 Sep 2007 17:52:09 +0000
Message-ID: <20070926175209.7613.98135.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Small fix for documentation.

Added (unsigned long long).

                                                      
---

 Documentation/accounting/getdelays.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index cbee3a2..056f024 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -208,9 +208,10 @@ void print_delayacct(struct taskstats *t)
 void task_context_switch_counts(struct taskstats *t)
 {
 	printf("\n\nTask   %15s%15s\n"
-	       "       %15lu%15lu\n",
+	       "       %15llu%15llu\n",
 	       "voluntary", "nonvoluntary",
-	       t->nvcsw, t->nivcsw);
+	       (unsigned long long)t->nvcsw,
+	       (unsigned long long)t->nivcsw);
 }
 
 void print_ioacct(struct taskstats *t)

