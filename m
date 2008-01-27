Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYA0CRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYA0CRu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYA0CRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:13 -0500
Received: from ns.suse.de ([195.135.220.2]:54325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbYA0CRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:10 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [2/18] BKL-removal: Remove incorrect BKL comment in ext2
Message-Id: <20080127021708.467DA14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No BKL used anywhere, so don't mention it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext2/inode.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/fs/ext2/inode.c
===================================================================
--- linux.orig/fs/ext2/inode.c
+++ linux/fs/ext2/inode.c
@@ -569,7 +569,6 @@ static void ext2_splice_branch(struct in
  *
  * `handle' can be NULL if create == 0.
  *
- * The BKL may not be held on entry here.  Be sure to take it early.
  * return > 0, # of blocks mapped or allocated.
  * return = 0, if plain lookup failed.
  * return < 0, error case.
