Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbXIUUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbXIUUst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763154AbXIUUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:32957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763117AbXIUUoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:55 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [13/45] x86_64: Increase VDSO_TEXT_OFFSET for ancient binutils
Message-Id: <20070921204454.B51F714EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For some reason old binutils genertate larger headers so
increase the text offset of the vdso to avoid linker errors.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/vdso/voffset.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/vdso/voffset.h
===================================================================
--- linux.orig/arch/x86_64/vdso/voffset.h
+++ linux/arch/x86_64/vdso/voffset.h
@@ -1 +1 @@
-#define VDSO_TEXT_OFFSET 0x500
+#define VDSO_TEXT_OFFSET 0x600
