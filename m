Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbXGIDB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbXGIDB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbXGIDBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:01:19 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:54045 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbXGIDBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:01:19 -0400
Date: Sun, 8 Jul 2007 23:01:17 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] security: unexport mmap_min_addr
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082300510.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

Remove unneeded export.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/security.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/security.c b/security/security.c
index 024484f..27e5863 100644
--- a/security/security.c
+++ b/security/security.c
@@ -177,5 +177,4 @@ EXPORT_SYMBOL_GPL(register_security);
 EXPORT_SYMBOL_GPL(unregister_security);
 EXPORT_SYMBOL_GPL(mod_reg_security);
 EXPORT_SYMBOL_GPL(mod_unreg_security);
-EXPORT_SYMBOL_GPL(mmap_min_addr);
 EXPORT_SYMBOL(security_ops);
-- 
1.5.0.6

