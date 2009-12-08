Return-Path: <linux-kernel-owner+w=401wt.eu-S966356AbZLHVRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966356AbZLHVRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966316AbZLHVQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49590 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966266AbZLHVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:36 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [26/31] HWPOISON: mention HWPoison in Kconfig entry
Message-Id: <20091208211642.8CEA1B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/Kconfig
===================================================================
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -257,7 +257,7 @@ config MEMORY_FAILURE
 	  special hardware support and typically ECC memory.
 
 config HWPOISON_INJECT
-	tristate "Poison pages injector"
+	tristate "HWPoison pages injector"
 	depends on MEMORY_FAILURE && DEBUG_KERNEL
 
 config NOMMU_INITIAL_TRIM_EXCESS
