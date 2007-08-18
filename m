Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbXHRJiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbXHRJiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXHRJh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:37:58 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:53321 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbXHRJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:37:58 -0400
Message-id: <737828602404912540@wsc.cz>
Subject: [PATCH 1/9] fs/select, remove unused macros
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <viro@zeniv.linux.org.uk>
Date: Sat, 18 Aug 2007 11:39:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/select, remove unused macros

this is due to preparation for global BIT macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 8754d87e5b6221e7d34cccef473588d5170b689e
tree 52ac6a983077ab5854dcacfa4b0e3323c7bbd9c8
parent 7129cd56f4f7f8d9f7cc9deb9a62291fc989cf91
author Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 21:39:36 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 21:39:36 +0200

 fs/select.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 53b3fe9..22647d4 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -179,11 +179,6 @@ get_max:
 	return max;
 }
 
-#define BIT(i)		(1UL << ((i)&(__NFDBITS-1)))
-#define MEM(i,m)	((m)+(unsigned)(i)/__NFDBITS)
-#define ISSET(i,m)	(((i)&*(m)) != 0)
-#define SET(i,m)	(*(m) |= (i))
-
 #define POLLIN_SET (POLLRDNORM | POLLRDBAND | POLLIN | POLLHUP | POLLERR)
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
