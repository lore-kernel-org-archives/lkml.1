Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZLECHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZLECHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZLECHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:07:21 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:1362 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZLECHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:07:18 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 5/5] avr32: Convert BUG() to use unreachable()
Date: Fri,  4 Dec 2009 17:44:54 -0800
Message-Id: <1259977494-24636-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4B19BAD3.1000808@caviumnetworks.com>
References: <4B19BAD3.1000808@caviumnetworks.com>
X-OriginalArrivalTime: 05 Dec 2009 01:45:03.0849 (UTC) FILETIME=[90A9C590:01CA754C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
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

