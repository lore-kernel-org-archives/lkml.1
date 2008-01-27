Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYA0CVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYA0CVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYA0CRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:46 -0500
Received: from ns.suse.de ([195.135.220.2]:54392 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbYA0CRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:24 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [16/18] BKL-removal: Convert socket fasync to unlocked_fasync
Message-Id: <20080127021723.24D1314D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: davem@davemloft.net

Signed-off-by: Andi Kleen <ak@suse.de>

---
 net/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/net/socket.c
===================================================================
--- linux.orig/net/socket.c
+++ linux/net/socket.c
@@ -131,7 +131,7 @@ static const struct file_operations sock
 	.mmap =		sock_mmap,
 	.open =		sock_no_open,	/* special open code to disallow open via /proc */
 	.release =	sock_close,
-	.fasync =	sock_fasync,
+	.unlocked_fasync = sock_fasync,
 	.sendpage =	sock_sendpage,
 	.splice_write = generic_splice_sendpage,
 };
