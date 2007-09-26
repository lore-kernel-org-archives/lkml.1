Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbXIZKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbXIZKjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXIZKjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:39:06 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:25530 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754467AbXIZKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:39:05 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: balbir@in.ibm.com
Cc: jlan@engr.sgi.com
From: Maxim Uvarov <muvarov@ru.mvista.com>
Subject: [PATCH] Since we have counters in __u64 format we have to print them
	with %llu macros.
Date: Wed, 26 Sep 2007 14:39:18 +0000
Message-ID: <20070926143918.6749.53939.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Small fix for documentation.


                                                      
---

 Documentation/accounting/getdelays.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index cbee3a2..73924df 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -208,7 +208,7 @@ void print_delayacct(struct taskstats *t)
 void task_context_switch_counts(struct taskstats *t)
 {
 	printf("\n\nTask   %15s%15s\n"
-	       "       %15lu%15lu\n",
+	       "       %15llu%15llu\n",
 	       "voluntary", "nonvoluntary",
 	       t->nvcsw, t->nivcsw);
 }

