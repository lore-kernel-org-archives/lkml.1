Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZGXDbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZGXDbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZGXDbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:31:20 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:55585 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbZGXDbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:31:20 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: improve help text for mm debug config options
Date: Fri, 24 Jul 2009 05:31:17 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <trivial@kernel.org>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907240531.18676.elendil@planet.nl>
X-OriginalArrivalTime: 24 Jul 2009 03:31:19.0593 (UTC) FILETIME=[358C9990:01CA0C0F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the help text for PAGE_POISONING.
Also fix some typos and improve consistency within the file.

Signed-of-by: Frans Pop <elendil@planet.nl>

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index aa99fd1..af7cfb4 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -6,7 +6,7 @@ config DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
-	  of memory corruptions.
+	  of memory corruption.
 
 config WANT_PAGE_DEBUG_FLAGS
 	bool
@@ -17,11 +17,11 @@ config PAGE_POISONING
 	depends on !HIBERNATION
 	select DEBUG_PAGEALLOC
 	select WANT_PAGE_DEBUG_FLAGS
-	help
+	---help---
 	   Fill the pages with poison patterns after free_pages() and verify
 	   the patterns before alloc_pages(). This results in a large slowdown,
-	   but helps to find certain types of memory corruptions.
+	   but helps to find certain types of memory corruption.
 
-	   This option cannot enalbe with hibernation. Otherwise, it will get
-	   wrong messages for memory corruption because the free pages are not
-	   saved to the suspend image.
+	   This option cannot be enabled in combination with hibernation as
+	   that would result in incorrect warnings of memory corruption after
+	   a resume because free pages are not saved to the suspend image.
