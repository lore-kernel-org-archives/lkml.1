Return-Path: <linux-kernel-owner+w=401wt.eu-S965943AbXLTPj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965943AbXLTPj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934172AbXLTPWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:35 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:33733 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933396AbXLTPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:10 -0500
Message-Id: <20071220152109.145602064@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:53 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 28/47] Remove appldata include from sysctl_check.c
Content-Disposition: inline; filename=127-appldata.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Forgot to remove this when removing the appldata binary sysctls.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 kernel/sysctl_check.c |    1 -
 1 file changed, 1 deletion(-)

Index: quilt-2.6/kernel/sysctl_check.c
===================================================================
--- quilt-2.6.orig/kernel/sysctl_check.c
+++ quilt-2.6/kernel/sysctl_check.c
@@ -1,6 +1,5 @@
 #include <linux/stat.h>
 #include <linux/sysctl.h>
-#include "../arch/s390/appldata/appldata.h"
 #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
 #include <linux/sunrpc/debug.h>
 #include <linux/string.h>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

