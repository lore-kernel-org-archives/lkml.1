Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXHSLIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXHSLIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 07:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXHSLIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 07:08:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35681 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXHSLIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 07:08:21 -0400
From: Christian Heim <phreak@gentoo.org>
Reply-To: phreak@gentoo.org
Organization: Gentoo Foundation, Inc.
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove double inclusion of linux/capability.h
Date: Sun, 19 Aug 2007 13:07:59 +0200
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191308.00043.phreak@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the second inclusion of linux/capability.h, which has been introduced with 
"[PATCH] move capable() to capability.h" (or commit c59ede7b78db329949d9cdcd7064e22d357560ef)

Signed-off-by: Christian Heim <phreak@gentoo.org>
---
 kernel/sysctl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8bdb8c0..9029690 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -27,7 +27,6 @@
 #include <linux/capability.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
-#include <linux/capability.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/init.h>
--
1.5.3.rc4
