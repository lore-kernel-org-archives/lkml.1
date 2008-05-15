Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbYEOPHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbYEOPHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932351AbYEOPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:04:10 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:23025 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbYEOPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:04:07 -0400
Message-Id: <20080515150007.788644684@de.ibm.com>
References: <20080515145705.188435204@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 16:57:07 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 02/11] Remove last traces of cio_msg=.
Content-Disposition: inline; filename=002-cio-cio_msg.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

cio_msg= is gone, also remove it from kernel-parameters.txt.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 Documentation/kernel-parameters.txt |    3 ---
 1 file changed, 3 deletions(-)

Index: quilt-2.6/Documentation/kernel-parameters.txt
===================================================================
--- quilt-2.6.orig/Documentation/kernel-parameters.txt
+++ quilt-2.6/Documentation/kernel-parameters.txt
@@ -398,9 +398,6 @@ and is between 256 and 4096 characters. 
 	cio_ignore=	[S390]
 			See Documentation/s390/CommonIO for details.
 
-	cio_msg=	[S390]
-			See Documentation/s390/CommonIO for details.
-
 	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
 			[Deprecated]
 			Forces specified clocksource (if available) to be used

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

