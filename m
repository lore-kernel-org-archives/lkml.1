Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZCJFQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZCJFQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZCJFLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:52 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:28373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZCJFLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TgK86VflPXKrnn7gAm2mudHwcilwyOviy5NMfxViVGoPeDkM9Sjd8KsRyIQSLaSX3G
         I0urO0I0Bh4mk0t5iROpqIpH9RynMYBJXNvxC5RCrO8DhzP6H5KxhB540Bq+gwyVkOWu
         XypJZJgN37YZ4pm/oyCt39PZr43eegEMIHOsE=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, starvik@axis.com,
       jesper.nilsson@axis.com, dev-etrax@axis.com
Subject: [PATCH 15/25] [cris] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:40 -0500
Message-Id: <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/cris/mm/init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/cris/mm/init.c b/arch/cris/mm/init.c
index 2fdd212..514f46a 100644
--- a/arch/cris/mm/init.c
+++ b/arch/cris/mm/init.c
@@ -25,8 +25,7 @@ mem_init(void)
 	int codesize, reservedpages, datasize, initsize;
 	unsigned long tmp;
 
-	if(!mem_map)
-		BUG();
+	BUG_ON(!mem_map);
 
 	/* max/min_low_pfn was set by setup.c
 	 * now we just copy it to some other necessary places...
-- 
1.6.1.3

