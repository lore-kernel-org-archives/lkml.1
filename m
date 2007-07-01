Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbXGAU1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbXGAU1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbXGAUXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46884 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759429AbXGAUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:00 -0400
Date: Sun, 1 Jul 2007 22:23:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Ollie Wild <aaw@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [-mm patch] unexport bprm_mm_init
Message-ID: <20070701202326.GT10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
> +mm-variable-length-argument-support.patch
>...
>  Remove the fixed command-line length limit
>...


bprm_mm_init doesn't have any modular users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/fs/exec.c.old	2007-06-30 04:18:22.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/exec.c	2007-06-30 04:18:36.000000000 +0200
@@ -379,7 +379,6 @@
 
 	return err;
 }
-EXPORT_SYMBOL(bprm_mm_init);
 
 /*
  * count() counts the number of strings in array ARGV.

