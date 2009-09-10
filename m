Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZIJX5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZIJX5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZIJX5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:57:44 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16141 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZIJX5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:57:43 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 09/10] avr32: Convert BUG() to use unreachable()
Date: Thu, 10 Sep 2009 16:56:50 -0700
Message-Id: <1252627011-2933-9-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AA991C1.1050800@caviumnetworks.com>
References: <4AA991C1.1050800@caviumnetworks.com>
X-OriginalArrivalTime: 10 Sep 2009 23:57:04.0829 (UTC) FILETIME=[65C106D0:01CA3272]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/include/asm/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/include/asm/bug.h b/arch/avr32/include/asm/bug.h
index 331d45b..2aa373c 100644
--- a/arch/avr32/include/asm/bug.h
+++ b/arch/avr32/include/asm/bug.h
@@ -52,7 +52,7 @@
 #define BUG()								\
 	do {								\
 		_BUG_OR_WARN(0);					\
-		for (;;);						\
+		unreachable();						\
 	} while (0)
 
 #define WARN_ON(condition)							\
-- 
1.6.2.5

