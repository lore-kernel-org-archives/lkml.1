Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYAKTBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYAKTBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761172AbYAKTBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:01:18 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:51155 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbYAKTBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:01:17 -0500
Date: Fri, 11 Jan 2008 20:01:06 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS: Define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS
Message-ID: <20080111190106.GF27482@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CRIS: Define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS

This allows us to use the commong sys_rt_sigsuspend instead of
having our own.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/unistd.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-cris/unistd.h b/include/asm-cris/unistd.h
index 6f2d924..bd57a79 100644
--- a/include/asm-cris/unistd.h
+++ b/include/asm-cris/unistd.h
@@ -358,6 +358,7 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
 
 /*
  * "Conditional" syscalls
-- 
1.5.3.6.970.gd25430

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
