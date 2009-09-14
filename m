Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbZINV6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbZINV6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbZINV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:58:04 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9418 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbZINV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:56:01 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 09/11] avr32: Convert BUG() to use unreachable()
Date: Mon, 14 Sep 2009 14:55:38 -0700
Message-Id: <1252965340-31735-9-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AAEBAC2.1050905@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
X-OriginalArrivalTime: 14 Sep 2009 21:55:58.0996 (UTC) FILETIME=[24A1E540:01CA3586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
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

