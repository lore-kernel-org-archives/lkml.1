Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZINV5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZINV5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbZINV5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:57:10 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9423 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbZINV4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:56:02 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 10/11] blackfin: Convert BUG() to use unreachable()
Date: Mon, 14 Sep 2009 14:55:39 -0700
Message-Id: <1252965340-31735-10-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4AAEBAC2.1050905@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
X-OriginalArrivalTime: 14 Sep 2009 21:55:59.0668 (UTC) FILETIME=[25086F40:01CA3586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
CC: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dist-devel@blackfin.uclinux.org
---
 arch/blackfin/include/asm/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/bug.h b/arch/blackfin/include/asm/bug.h
index 655e495..0b213a9 100644
--- a/arch/blackfin/include/asm/bug.h
+++ b/arch/blackfin/include/asm/bug.h
@@ -41,7 +41,7 @@
 #define BUG()								\
 	do {								\
 		_BUG_OR_WARN(0);					\
-		for (;;);						\
+		unreachable();						\
 	} while (0)
 
 #define WARN_ON(condition)							\
-- 
1.6.2.5

