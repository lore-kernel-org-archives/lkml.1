Return-Path: <linux-kernel-owner+w=401wt.eu-S1764096AbYECMZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764096AbYECMZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYECMZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:25:30 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:33648 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYECMZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:25:30 -0400
MIME-Version: 1.0
Date: Sat, 03 May 2008 14:25:25 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [OP]  added to queue-2.6.22.23-op1
Reply-To: oliver.pntr@gmail.com
Message-ID: <e6b437137f344f9a0ab657656ca7b533@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch added to queue-2.6.22.23-op1.
If anyone has any objections, please let us know.

http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
git://repo.or.cz/linux-2.6.22.y-op-patches.git

---

>From 12c2ab5e8fdfde67f3f6778a366cbdef06de410d Mon Sep 17 00:00:00 2001
From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 6 Feb 2008 01:36:47 -0800
Subject: [PATCH] fs/utimes.c should #include <linux/syscalls.h>

Every file should include the headers containing the prototypes for its
global
functions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/utimes.c b/fs/utimes.c
index b9912ec..e5588cd 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/utime.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 


