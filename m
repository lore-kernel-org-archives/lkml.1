Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbXFLLHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbXFLLHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXFLLHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:07:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60561 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754151AbXFLLHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:07:30 -0400
Date: Tue, 12 Jun 2007 13:07:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make cmdline_parse_kernelcore() static
Message-ID: <20070612110742.GV3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cmdline_parse_kernelcore() can become static.

---
--- linux-2.6.22-rc4-mm2/mm/page_alloc.c.old	2007-06-12 02:10:56.000000000 +0200
+++ linux-2.6.22-rc4-mm2/mm/page_alloc.c	2007-06-12 02:11:08.000000000 +0200
@@ -3879,7 +3879,7 @@
  * kernelcore=size sets the amount of memory for use for allocations that
  * cannot be reclaimed or migrated.
  */
-int __init cmdline_parse_kernelcore(char *p)
+static int __init cmdline_parse_kernelcore(char *p)
 {
 	unsigned long long coremem;
 	if (!p)

