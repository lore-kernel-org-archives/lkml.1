Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbZL3Acz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbZL3Acz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZL3Acz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:32:55 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39154 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbZL3Acy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:32:54 -0500
Date: Tue, 29 Dec 2009 19:32:15 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove macro MAXHOSTNAMELEN from <asm-generic/param.h>.
Message-ID: <alpine.LFD.2.00.0912291929010.6325@localhost>
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


Since nothing in the entire tree makes use of this macro, remove it.
This removal should eventually propagate to all of the arch-specific
param.h files.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  from the earlier discussion, no one provided any compelling reason
to retain this macro.  i'll eventually simplify the rest of the
param.h files similarly.  the fact that this macro is currently
exported to user space doesn't seem like any argument to keep it.

diff --git a/include/asm-generic/param.h b/include/asm-generic/param.h
index cdf8251..47939d8 100644
--- a/include/asm-generic/param.h
+++ b/include/asm-generic/param.h
@@ -19,6 +19,4 @@
 #define NOGROUP		(-1)
 #endif

-#define MAXHOSTNAMELEN	64	/* max length of hostname */
-
 #endif /* __ASM_GENERIC_PARAM_H */

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
