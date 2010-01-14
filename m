Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548Ab0ANNIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0ANNIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145Ab0ANNIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:08:23 -0500
Received: from smtp.nokia.com ([192.100.122.230]:31451 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab0ANNIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:08:20 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 1/3] Fix minor spelling error in comments
Date: Thu, 14 Jan 2010 15:07:21 +0200
Message-Id: <8c5b5f9532bdb31baa11432bea0039bf39854596.1263473812.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1263473812.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 14 Jan 2010 13:08:05.0608 (UTC) FILETIME=[9C37EE80:01CA951A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 arch/x86/mm/gup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 71da1bc..738e659 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -18,7 +18,7 @@ static inline pte_t gup_get_pte(pte_t *ptep)
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without taking
-	 * any locks.  For this we would like to load the pointers atoimcally,
+	 * any locks.  For this we would like to load the pointers atomically,
 	 * but that is not possible (without expensive cmpxchg8b) on PAE.  What
 	 * we do have is the guarantee that a pte will only either go from not
 	 * present to present, or present to not present or both -- it will not
-- 
1.5.6.5

