Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbYEOPFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbYEOPFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbYEOPED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:04:03 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:62099 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761042AbYEOPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:04:00 -0400
Message-Id: <20080515150008.584696442@de.ibm.com>
References: <20080515145705.188435204@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 16:57:10 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Huang Weiyi <weiyi.huang@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/11] blacklist.c: removed duplicated include
Content-Disposition: inline; filename=005-cio-include.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include <asm/cio.h>
in drivers/s390/cio/blacklist.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/blacklist.c |    1 -
 1 file changed, 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/blacklist.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/blacklist.c
+++ quilt-2.6/drivers/s390/cio/blacklist.c
@@ -19,7 +19,6 @@
 
 #include <asm/cio.h>
 #include <asm/uaccess.h>
-#include <asm/cio.h>
 
 #include "blacklist.h"
 #include "cio.h"

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

