Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbYAYSDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbYAYSDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbYAYSDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:03:16 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33704 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885AbYAYSDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:03:14 -0500
Date: Fri, 25 Jan 2008 19:03:49 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] hide kernel only code in linux/jbd.h
Message-ID: <20080125180349.GA30059@aepfle.de>
References: <20080125180215.GA30039@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080125180215.GA30039@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move a few kernel only stuff into __KERNEL__

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/linux/jbd.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -33,7 +33,6 @@
 #include <linux/lockdep.h>
 
 #include <asm/semaphore.h>
-#endif
 
 #define journal_oom_retry 1
 
@@ -84,7 +83,6 @@ static inline void jbd_free(void *ptr, s
 
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 
-#ifdef __KERNEL__
 
 /**
  * typedef handle_t - The handle_t type represents a single atomic update being performed by some process.
