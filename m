Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYHGRht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYHGRht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYHGRhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:37:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40224 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYHGRhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:37:38 -0400
Date: Thu, 7 Aug 2008 13:35:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove long-dead __setup_null_param() from init.h.
Message-ID: <alpine.LFD.1.10.0808071334410.2019@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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


This macro appears to have been unused for ages, and there are no
invocations of it anywhere in the source tree.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/init.h b/include/linux/init.h
index 11b84e1..40e5a0d 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -232,9 +232,6 @@ struct obs_kernel_param {
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }

-#define __setup_null_param(str, unique_id)			\
-	__setup_param(str, unique_id, NULL, 0)
-
 #define __setup(str, fn)					\
 	__setup_param(str, fn, fn, 0)

@@ -295,7 +292,6 @@ void __init parse_early_param(void);
 	void cleanup_module(void) __attribute__((alias(#exitfn)));

 #define __setup_param(str, unique_id, fn)	/* nothing */
-#define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
