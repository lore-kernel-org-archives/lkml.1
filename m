Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbXGAU3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbXGAU3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbXGAUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46913 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759337AbXGAUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:26 -0400
Date: Sun, 1 Jul 2007 22:23:53 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] unexport mmap_min_addr
Message-ID: <20070701202353.GZ10869@stusta.de>
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
>  git-selinux.patch
>...
>  git trees
>...


Unneeded export.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/security/security.c.old	2007-07-01 21:28:34.000000000 +0200
+++ linux-2.6.22-rc6-mm1/security/security.c	2007-07-01 21:28:41.000000000 +0200
@@ -177,5 +177,4 @@
 EXPORT_SYMBOL_GPL(unregister_security);
 EXPORT_SYMBOL_GPL(mod_reg_security);
 EXPORT_SYMBOL_GPL(mod_unreg_security);
-EXPORT_SYMBOL_GPL(mmap_min_addr);
 EXPORT_SYMBOL(security_ops);

