Return-Path: <linux-kernel-owner+w=401wt.eu-S1764408AbXKCAU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764408AbXKCAU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbXKCAEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:04:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57898 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762331AbXKCAEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:04:45 -0400
Date: Sat, 3 Nov 2007 01:04:21 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/signalfd.c should #include <linux/syscalls.h>
Message-ID: <20071103000421.GE4594@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case sys_signalfd()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8b3bc8f299ba6ce251a047cb5c6a7aabc95a4f39 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index fb7f7e8..60da986 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
+#include <linux/syscalls.h>
 
 struct signalfd_ctx {
 	sigset_t sigmask;
