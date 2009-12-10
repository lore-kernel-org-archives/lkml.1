Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbZLJR31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbZLJR31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761264AbZLJR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:29:26 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3882 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761225AbZLJR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:29:14 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       David Daney <ddaney@caviumnetworks.com>,
       Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 5/5] blackfin: Convert BUG() to use unreachable()
Date: Thu, 10 Dec 2009 09:28:21 -0800
Message-Id: <1260466101-17545-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4B212EEC.3060808@caviumnetworks.com>
References: <4B212EEC.3060808@caviumnetworks.com>
X-OriginalArrivalTime: 10 Dec 2009 17:28:30.0795 (UTC) FILETIME=[311901B0:01CA79BE]
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
index 6f4548a..75f6dc3 100644
--- a/arch/blackfin/include/asm/bug.h
+++ b/arch/blackfin/include/asm/bug.h
@@ -47,7 +47,7 @@
 #define BUG()								\
 	do {								\
 		_BUG_OR_WARN(0);					\
-		for (;;);						\
+		unreachable();						\
 	} while (0)
 
 #define WARN_ON(condition)							\
-- 
1.6.2.5

