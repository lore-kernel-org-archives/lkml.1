Return-Path: <linux-kernel-owner+w=401wt.eu-S2992726AbXEBE32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992726AbXEBE32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992715AbXEBE3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:29:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992726AbXEBE2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=ireK4bfXp8yuD7QtsKoZHFwA4SrEnmjYqMjFov3nvJlYGWTTSIfOlam0nABrkVVXN
	F0qMCPMd0+/J8OYWOytUA==
Date: Tue, 1 May 2007 21:28:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [patch 10/10] i386 mmzone: use __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012124060.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012124380.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012122480.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012123330.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012124060.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace automatic variable instances of __attribute__ ((unused)) with
__attribute_unused__.

Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/asm-i386/mmzone.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-i386/mmzone.h b/include/asm-i386/mmzone.h
--- a/include/asm-i386/mmzone.h
+++ b/include/asm-i386/mmzone.h
@@ -122,21 +122,21 @@ static inline int pfn_valid(int pfn)
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x)					\
 ({									\
-	struct pglist_data  __attribute__ ((unused))			\
+	struct pglist_data  __attribute_unused__			\
 				*__alloc_bootmem_node__pgdat = (pgdat);	\
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES,	\
 						__pa(MAX_DMA_ADDRESS));	\
 })
 #define alloc_bootmem_pages_node(pgdat, x)				\
 ({									\
-	struct pglist_data  __attribute__ ((unused))			\
+	struct pglist_data  __attribute_unused__			\
 				*__alloc_bootmem_node__pgdat = (pgdat);	\
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE,		\
 						__pa(MAX_DMA_ADDRESS))	\
 })
 #define alloc_bootmem_low_pages_node(pgdat, x)				\
 ({									\
-	struct pglist_data  __attribute__ ((unused))			\
+	struct pglist_data  __attribute_unused__			\
 				*__alloc_bootmem_node__pgdat = (pgdat);	\
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0);		\
 })
