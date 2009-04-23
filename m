Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZDWLtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZDWLtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZDWLsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:48:43 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:48893 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZDWLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:48:42 -0400
Message-Id: <20090423114725.022249915@de.ibm.com>
References: <20090423114638.865214111@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 23 Apr 2009 13:46:39 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/6] ipl: fix compile breakage
Content-Disposition: inline; filename=001-ipl-compile-breakage.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix this for !CONFIG_SMP:

arch/s390/kernel/ipl.c: In function 'stop_run':
arch/s390/kernel/ipl.c:1461: error: implicit declaration of function 'signal_processor'

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/arch/s390/kernel/ipl.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/ipl.c
+++ quilt-2.6/arch/s390/kernel/ipl.c
@@ -23,6 +23,7 @@
 #include <asm/ebcdic.h>
 #include <asm/reset.h>
 #include <asm/sclp.h>
+#include <asm/sigp.h>
 #include <asm/checksum.h>
 
 #define IPL_PARM_BLOCK_VERSION 0

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

