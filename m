Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXFUXxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXFUXxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXFUXv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:51:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35917 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755237AbXFUXv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:51:56 -0400
Date: Fri, 22 Jun 2007 01:52:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] mark calibrate_xor_blocks() __init
Message-ID: <20070621235215.GI23017@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm1:
>...
>  git-md-accel.patch
>...
>  git trees
>...

calibrate_xor_blocks() can be marked __init.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/crypto/xor.c.old	2007-06-21 23:47:56.000000000 +0200
+++ linux-2.6.22-rc4-mm2/crypto/xor.c	2007-06-21 23:48:39.000000000 +0200
@@ -94,7 +94,7 @@
 	       speed / 1000, speed % 1000);
 }
 
-static int
+static int __init
 calibrate_xor_blocks(void)
 {
 	void *b1, *b2;

