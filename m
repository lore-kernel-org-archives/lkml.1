Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZBVAHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZBVAHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZBVAGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:06:35 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:45397 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbZBVAGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:06:33 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 02/16] x86,
	numa_32.c: fix sparse warning: Using plain integer as NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:01:13 +0100
Message-ID: <20090222000105.17557.49889.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  arch/x86/mm/numa_32.c:197:24: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/mm/numa_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index d1f7439..3957cd6 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -194,7 +194,7 @@ void *alloc_remap(int nid, unsigned long size)
 	size = ALIGN(size, L1_CACHE_BYTES);
 
 	if (!allocation || (allocation + size) >= node_remap_end_vaddr[nid])
-		return 0;
+		return NULL;
 
 	node_remap_alloc_vaddr[nid] += size;
 	memset(allocation, 0, size);

