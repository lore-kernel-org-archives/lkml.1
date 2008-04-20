Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYDTOQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYDTOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYDTOQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:16:46 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:57063 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYDTOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:16:45 -0400
Date: Sun, 20 Apr 2008 10:16:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove unused macro __setup_null_param() from init.h.
Message-ID: <alpine.LFD.1.00.0804201013400.31368@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


Given that there are no invocations of this macro anywhere in the
source tree, it would seem safe to delete it.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  *is* there any remaining value to this macro?

diff --git a/include/linux/init.h b/include/linux/init.h
index fb58c04..4a6c55f 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -223,9 +223,6 @@ struct obs_kernel_param {
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }

-#define __setup_null_param(str, unique_id)			\
-	__setup_param(str, unique_id, NULL, 0)
-
 #define __setup(str, fn)					\
 	__setup_param(str, fn, fn, 0)

@@ -292,7 +289,6 @@ void __init parse_early_param(void);
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
