Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYLGLGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYLGLGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYLGLGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:06:25 -0500
Received: from ozlabs.org ([203.10.76.45]:39297 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbYLGLGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:06:24 -0500
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:36:17 +1030
Subject: [PATCH] sparc: replace for_each_cpu_mask_nr with for_each_cpu
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072136.17757.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple replacement, now the _nr is redundant.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/sparc64/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/sparc64/kernel/smp.c
+++ linux-2.6/arch/sparc64/kernel/smp.c
@@ -769,7 +769,7 @@ static void xcall_deliver(u64 data0, u64
 
 	/* Setup the initial cpu list.  */
 	cnt = 0;
-	for_each_cpu_mask_nr(i, *mask) {
+	for_each_cpu(i, mask) {
 		if (i == this_cpu || !cpu_online(i))
 			continue;
 		cpu_list[cnt++] = i;

