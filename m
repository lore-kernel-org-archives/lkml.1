Return-Path: <linux-kernel-owner+w=401wt.eu-S939880AbXHIMrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939880AbXHIMrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939330AbXHIMll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939663AbXHIMlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:40 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: zaitcev@redhat.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/12] x86_64: vdso.lds in arch/x86_64/vdso/.gitignore
Message-Id: <20070809124139.31D8114F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pete Zaitcev <zaitcev@redhat.com>
Create arch/x86_64/vdso/.gitignore and put vdso.lds into it.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

Utterly trivial but for some reason missing. V.odd. I must be
misunderstanding how this works, but just in case here's patch.

---
 arch/x86_64/vdso/.gitignore |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86_64/vdso/.gitignore
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/.gitignore
@@ -0,0 +1 @@
+vdso.lds
