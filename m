Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab0CKNvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:51:06 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:41297 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab0CKNvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:51:04 -0500
Date: Thu, 11 Mar 2010 08:49:21 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: linux-mm@kvack.org
Subject: [PATCH] MEMORY MANAGEMENT: Remove deprecated
 memclear_highpage_flush().
Message-ID: <alpine.LFD.2.00.1003110847220.6408@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since this routine is all of static, deprecated and unreferenced, it
seems safe to delete it.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---


diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 74152c0..c77f913 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -173,12 +173,6 @@ static inline void zero_user(struct page *page,
 	zero_user_segments(page, start, start + size, 0, 0);
 }

-static inline void __deprecated memclear_highpage_flush(struct page *page,
-			unsigned int offset, unsigned int size)
-{
-	zero_user(page, offset, size);
-}
-
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE

 static inline void copy_user_highpage(struct page *to, struct page *from,

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
