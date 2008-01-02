Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYABUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYABUmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYABUmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:42:05 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:60665 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYABUmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:42:05 -0500
Date: Wed, 2 Jan 2008 21:42:04 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: torvalds@linux-foundation.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Use __u64 in aligned_u64's definition
Message-ID: <Pine.LNX.4.64.0801022135500.14900@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


please cherrypick 35f2e577e432b28969710bc1fd4d9a4c0875f81b from
the git://computergmbh.de/linux repository from the "netfilter"
branch (or use patch below).

thanks,
Jan

==========

commit 35f2e577e432b28969710bc1fd4d9a4c0875f81b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:30:18 2008 +0100

    linux/types.h: Use __u64 for aligned_u64
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/types.h b/include/linux/types.h
index f4f8d19..b94c0e4 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -126,7 +126,7 @@ typedef		__s64		int64_t;
 #endif
 
 /* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 unsigned long long __attribute__((aligned(8)))
+#define aligned_u64 __u64 __attribute__((aligned(8)))
 #define aligned_be64 __be64 __attribute__((aligned(8)))
 #define aligned_le64 __le64 __attribute__((aligned(8)))
 

