Return-Path: <linux-kernel-owner+w=401wt.eu-S936484AbXLTPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936484AbXLTPfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbXLTPWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:21 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:61357 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445AbXLTPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:13 -0500
Message-Id: <20071220152111.146895069@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:20:02 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 37/47] Initialize sclp_ipl_info
Content-Disposition: inline; filename=136-sclp-ipl-info.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

The sclp ipl information has not been initialized. Therefore the ipl loadparm
and the "has_dump" flag have not been set correctly.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/arch/s390/kernel/ipl.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/ipl.c
+++ quilt-2.6/arch/s390/kernel/ipl.c
@@ -1262,6 +1262,7 @@ static void __init shutdown_actions_init
 static int __init s390_ipl_init(void)
 {
 	reipl_probe();
+	sclp_get_ipl_info(&sclp_ipl_info);
 	shutdown_actions_init();
 	shutdown_triggers_init();
 	return 0;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

